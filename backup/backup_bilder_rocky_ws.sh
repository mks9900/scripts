#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#

Target="/home/johanthor/hdd_storage/onedrive/Pictures/"

Source="/home/johanthor/Pictures/"

mount_test="/home/johanthor/backup_nas/Pictures"

# if [ -d "$mount_test" ];
echo "=========================================================="
echo "Speglar till Onedrive"
echo "=========================================================="
/usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '.DS_Store' --delete $Source $Target
Success=1;
# else
# echo "Målenheten är inte monterad!"
# Success=0

# fi

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Success"
echo "=========================================================="
