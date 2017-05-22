#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
#

Source=$HOME/diverse/Lightroom/lr-cat-2014-10-21
Target=$HOME/backup_nas/Lightroom
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie_1000=/run/media/johan/LACIE1000GB/backup/Lightroom
Exclude="*Previews.lrdata"

if [ "$DevSource" = "$Try" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -lrtvz --progress --delete --exclude=$Exclude $Source $Target
    Nas_Success=1; 
else
    echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
    Nas_Success=0
fi

# Synka till lacie1000 om den är monterad, annars avbryt:
if [ -d "$Lacie_1000" ]; then
    echo "=========================================================="
    echo "Speglar till Lacie 1000 Gb:"
    echo "=========================================================="
    /usr/bin/rsync -lrtvz --progress --delete --exclude=$Exclude $Source $Lacie_1000
    Lacie_1000_Success=1; 
else
    echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
    Lacie_1000_Success=0
fi

echo "Backup av Lightroom kördes den" `date` "till NAS ($Nas_Success), Lacie1000 ($Lacie_1000_Success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie_1000: $Lacie_1000_Success"
echo "=========================================================="
