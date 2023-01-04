#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#

<<<<<<< HEAD
Target="/home/johanthor/hdd_storage/onedrive/Pictures/"

Source="/home/johanthor/Pictures/"
=======
Source="/home/johanthor/Pictures/"

Target="/home/johanthor/hdd_storage/onedrive/Pictures/"
>>>>>>> 0ea52310747342fc87c1712bc6e4e8785063bc03

# mount_test="/home/johanthor/backup_nas/Pictures"

<<<<<<< HEAD
# if [ -d "$mount_test" ];
echo "=========================================================="
echo "Speglar till Onedrive"
echo "=========================================================="
/usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '.DS_Store' --delete $Source $Target
Success=1;
# else
# echo "Målenheten är inte monterad!"
# Success=0
=======
# if [ -d "$mount_test" ]; then
echo "=========================================================="
echo "Speglar till Onedrive:"
echo "=========================================================="
/usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '.DS_Store' --delete $Source $Target
# Nas_Success=1;
# else
# echo "Målenheten är inte monterad!"
# Nas_Success=0
>>>>>>> 0ea52310747342fc87c1712bc6e4e8785063bc03

# fi

echo "=========================================================="
<<<<<<< HEAD
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Success"
=======
# echo " Sammanställning av synk av följande enheter enligt nedan:"
# echo " $Source till $Target: $Nas_Success"
echo "Klar!"
>>>>>>> 0ea52310747342fc87c1712bc6e4e8785063bc03
echo "=========================================================="
