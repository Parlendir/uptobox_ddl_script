## Download from uptobox.com with premium account
##
## If the file exists on uptobox, it is downloaded to DESTINATION
## & a log is filed
## If not, the file link is put aside to be retried at the next run
## 

## variables

## link sample 
# https://uptobox.com/abcdefgh1234?aff_id=12345678

## account token 
TOKEN=<token>

## base ddl url
BASE_URL=https://uptobox.com/api/link

## file containing the links, one link per line
SOURCE=Liens.md
SOURCE_tmp=Liens_tmp.md

## log file
LOG=Utp_log.md

## folder to download files
DESTINATION=/download


# read all lines in the SOURCE

while read LIEN # url  
do
	# get the file id from the link
	# get what comes after uptobox.com
	FILE_CODE=$(echo $LIEN | awk -F '/' '{print $4}')  
	
	# and before aff_id
	#FILE_CODE=$(echo $FILE_CODE | awk -F '?' '{print $1}')
	FILE_CODE=${FILE_CODE:0:12}
	
	# build the full dl link
	URL="${BASE_URL}?file_code=${FILE_CODE}&token=${TOKEN}"

	# get the ddl link
	DOWNLOAD=$(/usr/bin/curl -s ${URL} | /usr/bin/jq -r '.data' | /usr/bin/jq -r '.dlLink')

	# get the file name
	FILE_NAME=$(echo $DOWNLOAD | awk -F '/' '{print $6}') 

	# download
	/usr/bin/wget -c -nc -P $DESTINATION $DOWNLOAD

	# if wget gets an error, the file is put aside fr the next scan
	if [ $? -ne 0 ]; then
		echo $LIEN >> ${SOURCE_tmp}
	else
		# write in the log if wget has succeeded
		echo "["${FILE_NAME:0:30}"]("${LIEN}")" >> ${LOG}
	fi

	# wait 1 second after dl complete
	sleep 1

done < ${SOURCE}

# when done, delete source file
rm ${SOURCE}

# be sure SOURCE_tmp exists
touch ${SOURCE_tmp}

# mv SOURCE_tmp to SOURCE
mv ${SOURCE_tmp} ${SOURCE}
