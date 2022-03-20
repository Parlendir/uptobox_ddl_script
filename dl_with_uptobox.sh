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
TOKEN=1111111111111111111111111111111111111

## base ddl url
BASE_URL=https://uptobox.com/api/link

## file containing the links, one link per line
SOURCE=/volume1/Echanges/syncthing/Obsidian/Uptobox/Liens.md
SOURCE_tmp=/volume1/Echanges/syncthing/Obsidian/Uptobox/Liens_tmp.md

## log file
LOG=/volume1/Echanges/syncthing/Obsidian/Uptobox/Utp_log.md

## folder to download files
DESTINATION=/volume2/Downloads/_Nouveau


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

	# if wget gets an error, the file is put aside for backup
	echo $LIEN 		>> ${SOURCE_tmp}
	echo ${FILE_NAME} 	>> ${SOURCE_tmp}
	echo "" 		>> ${SOURCE_tmp}
	
	# write in the log if wget has succeeded
	FILE_NAME_SHORT=${FILE_NAME:0:45}

	echo "["${FILE_NAME_SHORT}"]("${LIEN}")" >> ${LOG}

	# wait 1 second after dl complete
	sleep 1

done < ${SOURCE}

# when done, delete source file
rm ${SOURCE}

# be sure SOURCE_tmp exists
#touch ${SOURCE_tmp}

# mv SOURCE_tmp to SOURCE
#mv ${SOURCE_tmp} ${SOURCE}

# créer la source temporaire
touch ${SOURCE}

# décompresser toutes les archives zip récupérées puis 
# supprimer toutes les archives zip récupérées
unzip *.zip && rm *.zip 												# façon simple

# code de sortie sans erreur = 0
exit 0
