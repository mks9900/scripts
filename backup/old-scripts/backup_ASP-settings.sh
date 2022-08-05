#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source="/home/johan/.AfterShot"
DevSource="//ng-nas/backup"
NgNas=/home/johan/backup_nas
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie_1000=/run/media/johan/LACIE1000GB/backup
DropBox=/home/johan/Dropbox/Backup
Exclude=cache

# Synka till ng-nas om den är monterad, annars avbryt:
if [ "$DevSource" = "$Try" ]; then
    /usr/bin/rsync -lrtvz --delete --exclude="$Exclude" $Source $NgNas
    Nas_Success=1; 
else
    echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
    Nas_Success=0
fi

# Synka till lacie1000 om den är monterad, annars avbryt:
if [ -d "$Lacie_1000" ]; then
    /usr/bin/rsync -lrtvz  --delete --exclude="$Exclude" $Source $Lacie_1000
    Lacie_1000_Success=1; 
else
    echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
    Lacie_1000_Success=0;
fi

# Synka till Dropbox-mappen:
if [ -d "$DropBox" ]; then
    /usr/bin/rsync -lrtvz --delete --exclude="$Exclude" $Source $DropBox
    DropBox_Success=1; 
else
    echo "Dropbox-disken är ej monterad, synkar ej denna."
    DropBox_Success=0;
fi

echo "Backup av ASP-settings kördes den" `date` "till NAS ($Nas_Success), Lacie1000 ($Lacie_1000_Success), DropBox ($DropBox_Success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Synkade .AfterShotPro-katalogen till följande enheter:   "
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $NgNas: $Nas_Success"
echo " $Source till $Lacie_1000: $Lacie_1000_Success"
echo " $Source till $DropBox: $DropBox_Success"
echo "=========================================================="
