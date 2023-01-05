#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/.config/darktable till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# Source=$HOME/diverse/Exports
Source=$HOME/Dropbox/Bilder_och_filmer
Target=$HOME/backup_nas
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie_1T=/media/johan/LACIE1TB/backup
ExtDiskTwo=/media/johan/backup-ext/backup
#Dropbox=$HOME/cloud-storage/Dropbox
#usb64=/media/johan/ntfs

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

# Synka till Lacie1Tb om den är monterad, annars avbryt:
if [ -d "$Lacie_1T" ]; then
    echo "=========================================================="
    echo "Speglar till Lacie 1000 Gb:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Lacie_1T
    Lacie_1T_Success=1; 
else
    echo "=========================================================="
    echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
    echo "=========================================================="
    Lacie_1T_Success=0
fi

# Synka till backup-ext om den är monterad, annars avbryt:
if [ -d "$ExtDiskTwo" ]; then
    echo "=========================================================="
    echo "Speglar till ExtDiskTwo:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $ExtDiskTwo    
    ExtDiskTwo_Success=1; 
else
    echo "=========================================================="
    echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
    echo "=========================================================="
    ExtDiskTwo_Success=0;
fi

# Synka till Dropbox om den är monterad, annars avbryt:
#if [ -d "$Dropbox" ]; then
#    echo "=========================================================="
#    echo "Speglar till Dropbox:"
#    echo "=========================================================="
#    /usr/bin/rsync -hlrtvz --progress --delete $Source $Dropbox
#    Dropbox_Success=1; 
#else
#    echo "=========================================================="
#    echo "Dropbox är ej monterad, synkar ej denna."
#    echo "=========================================================="
#    Dropbox_Success=0
#fi

## Synka till USB64Gb om den är monterad, annars avbryt:
#if [ -d "$usb64" ]; then
#    echo "=========================================================="
#    echo "Speglar till usb64Gb:"
#    echo "=========================================================="
#    /usr/bin/rsync -hlrtvz --progress --delete $Source $usb64    
#    usb64_Success=1; 
#else
#    echo "=========================================================="
#    echo "usb64-disken är ej monterad, synkar ej denna."
#    echo "=========================================================="
#    usb64_Success=0;
#fi

echo "Backup av Exports kördes den" `date` "till NAS ($Nas_Success), Lacie1Tb ($Lacie_1T_Success), ExtDiskTwo ($ExtDiskTwo), Dropbox ($Dropbox_Success), Usb64Gb ($usb64_success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie_1T: $Lacie_1T_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
#echo " $Source till $Dropbox: $Dropbox_Success"
#echo " $Source till $usb64: $usb64_Success"
echo "=========================================================="
