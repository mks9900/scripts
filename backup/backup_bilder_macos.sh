#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source="/Volumes/Raw_photos/raws/"

Target="/Volumes/backup/Pictures/Raw/"

mount_test="/Volumes/Raw_photos"

if [ -d "$mount_test" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '.DS_Store' --delete $Source $Target
    Nas_Success=1;
else
    echo "Målenheten är inte monterad!"
    Nas_Success=0    

fi

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo "=========================================================="
