#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar bara xmp-filerna som darktable skapar i /home/johanthor/Pictures/Raw till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#
# Ta med trailing / för att inte skapa Raw-katalogen i målet:
Source="/home/johanthor/onedrive_privat/Pictures/Raw/"

Target_nas="/home/johanthor/backup_nas/Pictures/Raw/xmp"

Target_1drive="/home/johanthor/onedrive_privat/backup/xmp"

# mount_test="/Volumes/Raw_photos"

if [ -d "$Target_nas" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '*.jpg' --exclude '*.nef' --exclude '*.raf' --exclude '*.dng' --exclude '*.mp4' --exclude '*.avi' --exclude '*.MOV' --exclude '*.NEF' --exclude '.DS_Store' --delete $Source $Target_nas
    Nas_Success=1;
else
    echo "Målenheten är inte monterad!"
    Nas_Success=0
fi

if [ -d "$Target_1drive" ]; then
    echo "=========================================================="
    echo "Speglar till 1drive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtv --exclude 'lost+found' --exclude '.Trash-1000' --exclude '*.jpg' --exclude '*.nef' --exclude '*.raf' --exclude '*.dng' --exclude '*.mp4' --exclude '*.avi' --exclude '*.MOV' --exclude '*.NEF' --exclude '.DS_Store' --delete $Source $Target_1drive
    1drive_Success=1;
else
    echo "Målenheten är inte monterad!"
    1drive_Success=0

fi

echo "=========================================================="
echo " Sammanställning av xmp-filer synk av följande enheter enligt nedan:"
echo " $Source till $Target_nas: $Nas_Success"
echo " $Source till $Target_1drive: $1drive_Success"
echo "=========================================================="
