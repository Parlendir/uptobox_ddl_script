## Download from uptobox.com with your premium account

## other source : https://mon-cookbook-informatique.blogspot.com/2019/02/direct-download-on-uptobox-with-premium.html?m=1

## variables

## link sample 
# https://uptobox.com/abcdefgh1234?aff_id=12345678

## account token 
TOKEN=token

## base ddl url
BASE_URL=https://uptobox.com/api/link

## file containing the links, one link per line
SOURCE=/volume2/Downloads/serie/serie.txt

## log file
LOG=/volume2/Downloads/serie/uptobox_script.log

## folder to download files
DESTINATION=/volume2/Downloads/serie


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

	# write in the log
	echo ${FILE_NAME} " | " ${LIEN} " | " ${FILE_CODE} >> ${LOG}

# wait 1 second after dl complete
sleep 1

done < $SOURCE

# when done, delete source file
rm ${SOURCE}

# create empty SOURCE file
touch $SOURCE
