# uptobox ddl script

This short bash script allows, from console, cron, synology user scheduled tasks.... to download from uptobox.com with your premium account.

Here is how it works :
 
1. You configure this script to use a file as a source, your download folder and your uptobox premium account token 
2. You create a cronjob / scheduled task 
3. You grab some links from uptobox 
4. You put these links in the source file, somewhere easy for you to update
5. The script reads the file, download targets and empties the source file while producing a simple log
6. Rince and repeat from 3. to 5. :) 



The variables are :

### account token
TOKEN=put your token here
(found in your account settings, direct download must be **activated**)

### file containing the links, one link per line
SOURCE=put the file path here

### log file
LOG=put the log file path here

### folder to download files
DESTINATION=put the download folder path here


