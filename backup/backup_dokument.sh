#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/cloud-storage/onedrive/dokument till NAS.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source=$HOME/onedrive_privat/dokument
Target=$HOME/backup_nas
DevSource="//ng-nas-plan0/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"


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

echo "dokument, "`date` "till NAS ($Nas_Success)" >> ~/onedrive_privat/backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo "=========================================================="
