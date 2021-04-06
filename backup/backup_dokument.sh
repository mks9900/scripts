#!/bin/bash
#
# Synkar från hemkatalogens script-katalog till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# set -e

#
# Definitioner
#
Source=$HOME/cloud-storage/onedrive/dokument
DevSource=$HOME/backup_nas
Target=$HOME/backup_nas/
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"

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
#if [ -d "$OneTB_ntfs" ]; then
#    echo "=========================================================="
#    echo "Speglar till OneTB-disken:"
#    echo "=========================================================="
#    /usr/bin/rsync -hlrvtz --progress --delete $Source $OneTB_ntfs
#    OneTB_ntfs_Success=1; 
#else
#    echo "=========================================================="
#    echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
#    echo "=========================================================="
#    OneTB_ntfs_Success=0
#fi

echo "dokument, "`date` "till NAS ($Nas_Success)" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
#echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
echo "=========================================================="
