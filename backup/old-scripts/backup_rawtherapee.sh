#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/.config/darktable till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source=$HOME/.config/RawTherapee5
Target=$HOME/backup_nas
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
OneTB_ntfs=/media/johan/OneTB_ntfs/backup
#ExtDiskTwo=/media/johan/backup-ext/backup
onedrive=$HOME/cloud-storage/onedrive/backup/rawtherapee


if [ "$DevSource" = "$Try" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Target
    Nas_Success=1; 
else
    echo "=========================================================="
    echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
    echo "=========================================================="
    Nas_Success=0
fi

# Synka till OneTB_ntfs om den är monterad, annars avbryt:
if [ -d "$OneTB_ntfs" ]; then
    echo "=========================================================="
    echo "Speglar till OneTB_ntfs:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $OneTB_ntfs
    OneTB_ntfs_Success=1; 
else
    echo "=========================================================="
    echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
    echo "=========================================================="
    OneTB_ntfs_Success=0
fi

# Synka till backup-ext om den är monterad, annars avbryt:
#if [ -d "$ExtDiskTwo" ]; then
#    echo "=========================================================="
#    echo "Speglar till ExtDiskTwo:"
#    echo "=========================================================="
#    /usr/bin/rsync -hlrtvz --progress --delete $Source $ExtDiskTwo    
#    ExtDiskTwo_Success=1; 
#else
#    echo "=========================================================="
#    echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
#    echo "=========================================================="
#    ExtDiskTwo_Success=0;
#fi

# Synka till onedrive om den är monterad, annars avbryt:
if [ -d "$onedrive" ]; then
    echo "=========================================================="
    echo "Speglar till onedrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $onedrive
    onedrive_Success=1; 
else
    echo "=========================================================="
    echo "onedrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    onedrive_Success=0
fi

echo "RawTherapee, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), onedrive ($onedrive_Success)" >> ~/Backup_dates_disks.txt

#echo "RawTherapee, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), ExtDiskTwo ($ExtDiskTwo_Success), onedrive ($onedrive_Success)" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
#echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo " $Source till $onedrive: $onedrive_Success"
echo "=========================================================="
