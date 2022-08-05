#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/.config/darktable till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source=/home/johan/.fluxbox
Target=/home/johan/backup_nas
Mount="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup |awk '{print $1}'`"
Lacie_1000=/run/media/johan/LACIE1000GB/backup
DropBox=/home/johan/backup_nas/Dropbox/Backup

if [ "$Mount" = "$Try" ]; then
    /usr/bin/rsync -lrtvz --progress --delete $Source $Target
    Nas_Success=1; 
else
    echo "Enheten $Mount är ej monterad på $Source. Avbryter."
    Nas_Success=0; 
fi

# Synka till lacie1000 om den är monterad, annars avbryt:
if [ -d "$Lacie_1000" ]; then
    /usr/bin/rsync -lrtvz --progress --delete $Source $Lacie_1000
    Lacie_1000_Success=1; 
else
    echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
    Lacie_1000_Success=0; 
fi

# Synka till Dropbox-mappen:
if [ -d "$DropBox" ]; then
    /usr/bin/rsync -lrtvz --delete $Source $DropBox
    DropBox_Success=1; 
else
    echo "Dropbox-disken är ej monterad, synkar ej denna."
    DropBox_Success=0;
fi

echo "Backup av fluxbox kördes den" `date` "till NAS ($Nas_Success), Lacie1000 ($Lacie_1000_Success), DropBox ($DropBox_Success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie_1000: $Lacie_1000_Success"
echo " $Source till $DropBox: $DropBox_Success"
echo "=========================================================="
