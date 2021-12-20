# uptobox ddl script

This short bash script allows, from console, cron, synology user scheduled tasks.... to download from uptobox.com with your premium account.

Here is how it works :

The variables are : 

## account token : found in your account settings, direct download must be **activated**
TOKEN=put your token here

## base ddl url
BASE_URL=https://uptobox.com/api/link

## file containing the links, one link per line
SOURCE=put the file path here

## log file
LOG=put the log file path here

## folder to download files
DESTINATION=put the download folder path here
