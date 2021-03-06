#!/bin/sh

if [ $# -lt 1 ]; then 
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
elif [ ! -d "$1" ]; then
   echo "Invalid path: $1" >&2
   exit 1
elif [ ! -w "$1" ]; then
   echo "Directory not writable: $1" >&2
   exit 1
fi

case "$1" in
  "/mnt") ;;
  "/mnt/"*) ;;
  "/media") ;;
  "/media/"*) ;;
  "/home/johan/backup_nas/gentoo-fullbackup") ;;
  "/home/johan/backup_nas/gentoo-fullbackup/"*) ;;
  "/home/johan/tmp") ;;
  "/home/johan/tmp/"*) ;;
  *) echo "Destination not allowed." >&2 
     exit 1 
     ;;
esac

START=$(date +%s)
rsync -hrzv /* $1 --exclude /dev/* --exclude /proc/* --exclude /sys/* --exclude /tmp/* --exclude /run/* --exclude /mnt/* --exclude /media/* --exclude /lost+found --exclude /usr/portage/* --exclude /home/*
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

touch $1/"Backup from $(date '+%A, %d %B %Y, %T')"
