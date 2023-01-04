#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source="/home/johanthor/Pictures/"

Target="/home/johanthor/hdd_storage/onedrive/Pictures/"
# mount_test="/home/johanthor/backup_nas/Pictures"

echo "=========================================================="
echo "Speglar till Onedrive"
echo "=========================================================="
/usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '.DS_Store' --delete $Source $Target
Success=1;

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Success"
echo "Klar!"
echo "=========================================================="
