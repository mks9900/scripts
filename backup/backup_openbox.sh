#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/.config/darktable till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

Source=/home/johan/.config/openbox
Target=/home/johan/backup_nas
DevSource="//ng-nas/backup"
TRY="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie1T=/media/johan/LACIE1TB/backup
ExtDiskTwo=/media/johan/backup-ext/backup
Dropbox=$HOME/cloud-storage/Dropbox/backup
GoogleDrive=$HOME/diverse/gdrive/backup

if [ "$DevSource" = "$TRY" ]; then
    echo "=========================================================="
    echo "Speglar till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Target
    Nas_Success=1; 
else
    echo "=========================================================="
    echo "Enheten $DevSource är ej monterad på $Source, synkar ej denna."
    echo "=========================================================="
    Nas_Success=0; 
fi

# Synka till lacie1000 om den är monterad, annars avbryt:
if [ -d "$Lacie1T" ]; then
    echo "=========================================================="
    echo "Speglar till Lacie 1000 Gb:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $Source $Lacie1T
    Lacie1T_Success=1; 
else
    echo "=========================================================="
    echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
    echo "=========================================================="
    Lacie1T_Success=0; 
fi

# Synka till backup-ext om den är monterad, annars avbryt:
if [ -d "$ExtDiskTwo" ]; then
    /usr/bin/rsync -hlrtvz --progress --delete $Source $ExtDiskTwo
    echo "=========================================================="
    echo "Speglar till ExtDiskTwo:"
    echo "=========================================================="
    
    ExtDiskTwo_Success=1; 
else
    echo "=========================================================="
    echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
    echo "=========================================================="
    ExtDiskTwo_Success=0;
fi

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

echo "Backup av openbox kördes den" `date` "till NAS ($Nas_Success), Lacie1000 ($Lacie1T_Success), Dropbox ($Dropbox_Success), GoogleDrive ($GoogleDrive_Success)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie1T: $Lacie1T_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo " $Source till $Dropbox: $Dropbox_Success"
echo " $Source till $GoogleDrive: $GoogleDrive_Success"
echo "=========================================================="
