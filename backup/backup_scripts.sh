#!/bin/bash
#
# Synkar från hemkatalogens script-katalog till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# set -e

#
# Definitioner
#
Source=$HOME/cloud-storage/Dropbox/scripts
# DevSource=$HOME/backup_nas/scripts
Target=$HOME/backup_nas
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
OneTB_ntfs=/media/johan/OneTB_ntfs/backup
#ExtDiskTwo=/media/johan/backup-ext/backup
Dropbox=$HOME/cloud-storage/Dropbox/backup
#GoogleDrive=$HOME/gdrive/backup

#
# Kollar om NAS:en är monterad.
if [ "$DevSource" = "$Try" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrvtz --progress --delete $Source $Target
    Nas_Success=1; 
else
    echo "=========================================================="
    echo "Enheten $DevSource är ej monterad på $Source, synkar ej denna."
    echo "=========================================================="
    Nas_Success=0; 
fi

# Synka till OneTB_ntfs om den är monterad, annars avbryt:
if [ -d "$OneTB_ntfs" ]; then
    echo "=========================================================="
    echo "Speglar till Lacie 1Tb:"
    echo "=========================================================="
    /usr/bin/rsync -hlrvtz --progress --delete $Source $OneTB_ntfs
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

# Synka till Dropbox om den är monterad, annars avbryt:
if [ -d "$Dropbox" ]; then
    echo "=========================================================="
    echo "Speglar till Dropbox:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Dropbox
    Dropbox_Success=1; 
else
    echo "=========================================================="
    echo "Dropbox är ej monterad, synkar ej denna."
    echo "=========================================================="
    Dropbox_Success=0
fi

# Synka till GoogleDrive om den är monterad, annars avbryt:
#if [ -d "$GoogleDrive" ]; then
#    echo "=========================================================="
#    echo "Speglar till GoogleDrive:"
#    echo "=========================================================="
#    /usr/bin/rsync -hlrtvz --progress --delete $Source $GoogleDrive
#    GoogleDrive_Success=1; 
#else
#    echo "=========================================================="
#    echo "GoogleDrive är ej monterad, synkar ej denna."
#    echo "=========================================================="
#    GoogleDrive_Success=0
#fi

echo "Scripts, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), Dropbox ($Dropbox_Success)" >> ~/Backup_dates_disks.txt

#echo "Scripts, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), ExtDiskTwo ($ExtDiskTwo_Success), Dropbox ($Dropbox_Success)" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
#echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo " $Source till $Dropbox: $Dropbox_Success"
echo "=========================================================="
