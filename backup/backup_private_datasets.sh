#!/bin/zsh
#
# Synkar från hemkatalogens script-katalog till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# set -e

#
# Definitioner
#
Source=$HOME/code/datasets
Target=$HOME/backup_nas/coding/
DevSource="//ng-nas-plan0/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Onedrive=$HOME/onedrive_privat/backup/coding/

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

# Synka till Onedrive om den är monterad, annars avbryt:
if [ -d "$Onedrive" ]; then
    echo "=========================================================="
    echo "Speglar till Onedrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Onedrive
    Onedrive_Success=1; 
else
    echo "=========================================================="
    echo "Onedrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    Onedrive_Success=0
fi

echo "datasets, " `date` "till NAS ($Nas_Success), Onedrive ($Onedrive_Success)" >> ~/onedrive_privat/backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Onedrive: $Onedrive_Success"
echo "=========================================================="
