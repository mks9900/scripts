#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

SourceBase=$HOME
AllPath=Pictures
YearPath="$AllPath/Fotografier"
DevSource="//ng-nas/backup"
TRY="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
NgNasBase=/home/johan/backup_nas
OneTB_ntfsBase=/media/johan/OneTB_ntfs/backup
ExtDiskTwoBase=/media/johan/backup-ext/backup
#Dropbox=$HOME/cloud-storage/Dropbox

#Source="$SourceBase""/""$AllPath"
Source="/home/johan/cloud-storage/Dropbox/Pictures"
NgNas="$NgNasBase"
OneTB_ntfs="$OneTB_ntfsBase"
ExtDiskTwo="$ExtDiskTwoBase"

echo "Till vilken enhet vill du säkerhetskopiera?"
select enhet in Alla NAS OneTB_ntfs ExtDiskTwo; do # Dropbox; do 
    case $enhet in
	Alla ) echo "Speglar till NAS, OneTB_ntfs, ExtDiskTwo";
	       # Synka först till ng-nas om den är monterad, annars avbryt:
	       if [ "$DevSource" = "$TRY" ]; then
		   echo "Säkerhetskopierar till alla backup-enheter.";
		   echo "=========================================================="
		   echo "Speglar till ng-nas:"
		   echo "=========================================================="

		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		   Nas_Success=0
	       fi

	       # Synka sedan till OneTB_ntfs om den är monterad, annars avbryt:
	       if [ -d "$OneTB_ntfs" ]; then
		   echo "=========================================================="
		   echo "Speglar till OneTB_ntfs:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source "$OneTB_ntfs"
		   OneTB_ntfs_Success=1; 
	       else
		   echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
		   OneTB_ntfs_Success=0;
	       fi

	       # Synka sedan till ExtDiskTwo om den är monterad, annars avbryt:
	       if [ -d "$ExtDiskTwo" ]; then
		   echo "=========================================================="
		   echo "Speglar till ExtDiskTwo:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $ExtDiskTwo
		   ExtDiskTwo_Success=1; 
	       else
		   echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
		   ExtDiskTwo_Success=0;
	       fi

	       # Synka till Dropbox om den är monterad, annars avbryt:
#	       if [ -d "$Dropbox" ]; then
#		   echo "=========================================================="
#		   echo "Speglar till Dropbox:"
#		   echo "=========================================================="
#		   /usr/bin/rsync -hlrtvz --progress --delete $Source $Dropbox
#		   Dropbox_Success=1; 
#	       else
#		   echo "=========================================================="
#		   echo "Dropbox är ej monterad, synkar ej denna."
#		   echo "=========================================================="
#		   Dropbox_Success=0
#	       fi
	       
	       break;;
	
	NAS ) echo "Speglar till NAS:en.";
	      # Synka till ng-nas om den är monterad, annars avbryt:
	      if [ "$DevSource" = "$TRY" ]; then
		  echo "=========================================================="
		  echo "Speglar till ng-nas:"
		  echo "=========================================================="
		  /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $NgNas
#		  echo $Source/
#		  echo $NgNas/
		  Nas_Success=1; 
	      else
		  echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		  Nas_Success=0;
	      fi
	      break;;
	
	OneTB_ntfs ) echo "Speglar till OneTB_ntfs.";
		  # Synka till OneTB_ntfs om den är monterad, annars avbryt:
		  if [ -d "$OneTB_ntfs" ]; then
		      echo "=========================================================="
		      echo "Speglar till OneTB_ntfs:"
		      echo "=========================================================="
		      /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source "$OneTB_ntfs"
		      OneTB_ntfs_Success=1; 
		  else
		      echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
		      OneTB_ntfs_Success=0;
		  fi
		  
		  break;;

	ExtDiskTwo ) echo "Speglar till ExtDiskTwo.";
		     # Synka till backup-ext om den är monterad, annars avbryt:
		     if [ -d "$ExtDiskTwo" ]; then
			 echo "=========================================================="
			 echo "Speglar till ExtDiskTwo:"
			 echo "=========================================================="
		      /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $ExtDiskTwo
		      ExtDiskTwo_Success=1; 
		     else
			 echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
			 ExtDiskTwo_Success=0;
		     fi
		     
		     break;;

#	Dropbox ) echo "Speglar till ExtDiskTwo.";
#		  # Synka till Dropbox om den är monterad, annars avbryt:
#		  if [ -d "$Dropbox" ]; then
#		      echo "=========================================================="
#		      echo "Speglar till Dropbox:"
#		      echo "=========================================================="
#		      /usr/bin/rsync -hlrtvz --progress --delete $Source $Dropbox
#		      Dropbox_Success=1; 
#		  else
#		      echo "=========================================================="
#		      echo "Dropbox är ej monterad, synkar ej denna."
#		      echo "=========================================================="
#		      Dropbox_Success=0
#		  fi

#		  break;;
    esac
done

echo "Bilder," `date`" till $enhet" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo 
echo " $Source till $NgNas: $Nas_Success"
echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo "=========================================================="
