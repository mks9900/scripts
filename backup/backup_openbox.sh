#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/.config/darktable till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source=$HOME/.config/openbox
Target=$HOME/backup_nas
DevSource="//ng-nas-plan0/backup"
TRY="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
onedrive=$HOME/onedrive_privat/backup


if [ "$DevSource" = "$TRY" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Target
    Nas_Success=1; 
else
    echo "=========================================================="
    echo "Enheten $DevSource är ej monterad på $Source, synkar ej denna."
    echo "=========================================================="
    Nas_Success=0; 
fi

# Synka till Onedrive om den är monterad, annars avbryt:
if [ -d "$onedrive" ]; then
    echo "=========================================================="
    echo "Speglar till Onedrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $onedrive
    onedrive_Success=1; 
else
    echo "=========================================================="
    echo "Onedrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    onedrive_Success=0
fi

echo "Openbox, "`date` "till NAS ($Nas_Success), onedrive ($onedrive_Success)" >> ~/onedrive_privat/backup_dates_disks.txt

#echo "Openbox, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), ExtDiskTwo ($ExtDiskTwo_Success), onedrive ($onedrive_Success)" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $onedrive: $onedrive_Success"
echo "=========================================================="
