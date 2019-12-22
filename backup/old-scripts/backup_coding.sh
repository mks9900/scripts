#!/bin/bash
#
# Synkar från hemkatalogens script-katalog till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# set -e

#
# Definitioner
#
Source=$HOME/gdrive/coding
Target=$HOME/backup_nas
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie_1T=/media/johan/LACIE1TB/backup
ExtDiskTwo=/media/johan/backup-ext/backup
GoogleDrive=$HOME/gdrive/backup

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

# Synka till Lacie1Tb om den är monterad, annars avbryt:
if [ -d "$Lacie_1T" ]; then
    echo "=========================================================="
    echo "Speglar till Lacie 1Tb:"
    echo "=========================================================="
    /usr/bin/rsync -hlrvtz --progress --delete $Source $Lacie_1T
    Lacie_1T_Success=1; 
else
    echo "=========================================================="
    echo "Lacie1Tb-disken är ej monterad, synkar ej denna."
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
# if [ -d "$Dropbox" ]; then
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

# Synka till GoogleDrive om den är monterad, annars avbryt:
if [ -d "$GoogleDrive" ]; then
    echo "=========================================================="
    echo "Speglar till GoogleDrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $GoogleDrive
    GoogleDrive_Success=1; 
else
    echo "=========================================================="
    echo "GoogleDrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    GoogleDrive_Success=0
fi

echo "Backup av scripten kördes den" `date` "till NAS ($Nas_Success), Lacie1Tb ($Lacie_1T_Success), ExtDiskTwo ($ExtDiskTwo), GoogleDrive ($GoogleDrive_Success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie_1T: $Lacie_1T_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo " $Source till $GoogleDrive: $GoogleDrive_Success"
echo "=========================================================="
