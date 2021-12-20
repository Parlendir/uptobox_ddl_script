## Download from uptobox.com with premium account

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
	FILE_CODE=$(echo $FILE_CODE | awk -F '?' '{print $1}')

	# build the full dl link
	URL="${BASE_URL}?token=${TOKEN}&file_code=${FILE_CODE}"

	# get the ddl link
	DOWNLOAD=$(/usr/bin/curl -s ${URL} | /usr/bin/jq -r '.data' | /usr/bin/jq -r '.dlLink')

	# get the file name
	FILE_NAME=$(echo $DOWNLOAD | awk -F '/' '{print $6}') 

	# download
	/usr/bin/wget -c -nc -P $DESTINATION $DOWNLOAD

	# write in the log
	echo ${FILE_NAME} " / " ${LIEN} >> ${LOG}

# one file per 20 seconds
sleep 20

done < $SOURCE

# when done, delete source file
rm ${SOURCE}

# create empty SOURCE file
touch $SOURCE

