#!/bin/zsh
#
# Synkar från hemkatalogens script-katalog till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

# set -e

#
# Definitioner
#
SourceSSH=$HOME/.ssh
TargetSSH=$HOME/backup_nas/ssh/rocky_ws

# tar-gz the git-configs:
/usr/bin/tar -czvf dot_git_configs.tar.gz /home/johanthor/.gitconfig*

SourceGit=$HOME/dot_git_configs.tar.gz
TargetGit=$HOME/backup_nas/git/rocky_ws


DevSource="//ng-nas-plan0/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
OnedriveSSH=$HOME/onedrive_privat/backup/ssh/rocky_ws
OnedriveGit=$HOME/onedrive_privat/backup/git/rocky_ws

#
# Kollar om NAS:en är monterad.
if [ "$DevSource" = "$Try" ]; then
    echo "=========================================================="
    echo "Speglar SSH till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrvtz --progress --delete $SourceSSH $TargetSSH
    Nas_Success=1; 
else
    echo "=========================================================="
    echo "Enheten $DevSource är ej monterad på $Source, synkar ej denna."
    echo "=========================================================="
    Nas_Success=0; 
fi
# Kollar om NAS:en är monterad.
if [ "$DevSource" = "$Try" ]; then
    echo "=========================================================="
    echo "Speglar Git till ng-nas:"
    echo "=========================================================="
    /usr/bin/rsync -hlrvtz --progress --delete $SourceGit $TargetGit
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
    echo "Speglar SSH till Onedrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $SourceSSH $OnedriveSSH
    Onedrive_Success=1; 
else
    echo "=========================================================="
    echo "Onedrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    Onedrive_Success=0
fi
if [ -d "$Onedrive" ]; then
    echo "=========================================================="
    echo "Speglar Git till Onedrive:"
    echo "=========================================================="
    /usr/bin/rsync -hlrtvz --progress --delete $SourceGit $OnedriveGit
    Onedrive_Success=1; 
else
    echo "=========================================================="
    echo "Onedrive är ej monterad, synkar ej denna."
    echo "=========================================================="
    Onedrive_Success=0
fi

echo "ssh, git, "`date` "till NAS ($Nas_Success), Onedrive ($Onedrive_Success)" >> ~/onedrive_privat/backup_dates_disks.txt
echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Onedrive: $Onedrive_Success"
echo "=========================================================="
