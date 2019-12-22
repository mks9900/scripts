#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Musiktill NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

#
# Definitioner:
#
Source=$HOME/cloud-storage/Dropbox/Dokument
DevSource="//ng-nas/backup"
TRY="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
NgNas=/home/johan/backup_nas
OneTB_ntfs=/media/johan/OneTB_ntfs/backup
#ExtDiskTwo=/media/johan/backup-ext/backup
#
# Slut definitioner
#

echo "Till vilken enhet vill du säkerhetskopiera?"
#select enhet in Alla NAS OneTB_ntfs ExtDiskTwo; do
select enhet in Alla NAS OneTB_ntfs; do
    case $enhet in
	Alla ) echo "Säkerhetskopierar till alla backup-enheter.";
	       # Synka till ng-nas om den är monterad, annars avbryt:
	       echo "=========================================================="
	       echo "Speglar till ng-nas:"
	       echo "=========================================================="
	       if [ "$DevSource" = "//ng-nas/backup" ]; then
		   /usr/bin/rsync -hlrtvz --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $NgNas. Avbryter."
		   Nas_Success=0
	       fi

	       # Synka till OneTB_ntfs om den är monterad, annars avbryt:
	       if [ -d "$OneTB_ntfs" ]; then
		   echo "=========================================================="
		   echo "Speglar till OneTB_ntfs:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --delete $Source $OneTB_ntfs
		   OneTB_ntfs_Success=1; 
	       else
		   echo "=========================================================="
		   echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
		   echo "=========================================================="
		   OneTB_ntfs_Success=0
	       fi

	       ## Synka till ext-disk om den är monterad, annars avbryt:
	       #if [ -d "$ExtDiskTwo" ]; then
		   #echo "=========================================================="
		   #echo "Speglar till ext-disk:"
		   #echo "=========================================================="
		   #/usr/bin/rsync -hlrtvz --delete $Source $ExtDiskTwo
		   #ExtDiskTwo_Success=1; 
	       #else
		   #echo "=========================================================="
		   #echo "Extdisk-disken är ej monterad, synkar ej denna."
		   #echo "=========================================================="
		   #ExtDiskTwo_Success=0
	       #fi

	       # Synka till GoogleDrive om den är monterad, annars avbryt:
#	       if [ -d "$GoogleDrive" ]; then
#		   echo "=========================================================="
#		   echo "Speglar till GoogleDrive:"
#		   echo "=========================================================="
#		   /usr/bin/rsync -hlrtvz --progress --delete $Source $GoogleDrive
#		   GoogleDrive_Success=1; 
#	       else
#		   echo "=========================================================="
#		   echo "GoogleDrive är ej monterad, synkar ej denna."
#		   echo "=========================================================="
#		   GoogleDrive_Success=0
#	       fi
#
 	       break;;

	NAS ) echo "=========================================================="
	      echo "Speglar till ng-nas:"
	      echo "=========================================================="
	      # Synka till ng-nas om den är monterad, annars avbryt:
	       if [ "$DevSource" = "//ng-nas/backup" ]; then #Try
		   /usr/bin/rsync -hlrtvz --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $NgNas. Synkar ej denna."
		   Nas_Success=0
	       fi
	       break;;
	      
	OneTB_ntfs ) echo "=========================================================="
		    echo "Speglar till OneTB_ntfs:"
		    echo "=========================================================="
		    # Synka till OneTB_ntfs om den är monterad, annars avbryt:
		    if [ -d "$OneTB_ntfs" ]; then
			/usr/bin/rsync -hlrtvz --delete $Source $OneTB_ntfs
			OneTB_ntfs_Success=1; 
		    else
			echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
			OneTB_ntfs_Success=0;
		    fi
		    break;;

#	ExtDiskTwo ) echo "=========================================================="
#		     echo "Speglar till ExtDiskTwo:"
#		     echo "=========================================================="
#		     
#		     # Synka till ext-disk om den är monterad, annars avbryt:
#		     if [ -d "$ExtDiskTwo" ]; then
#			 echo "=========================================================="
#			 echo "Speglar till ext-disk:"
#			 echo "=========================================================="
#			 /usr/bin/rsync -hlrtvz --delete $Source $ExtDiskTwo
#			 ExtDiskTwo_Success=1; 
#		     else
#			 echo "=========================================================="
#			 echo "Extdisk-disken är ej monterad, synkar ej denna."
#			 echo "=========================================================="
#			 ExtDiskTwo_Success=0
#		     fi
#		     break;;
	
#	Dropbox ) echo "=========================================================="
#		  echo "Speglar till Dropbox:"
#		  echo "=========================================================="
#		  # Synka till Dropbox om den är monterad, annars avbryt:
#		  if [ -d "$Dropbox" ]; then
#		      echo "=========================================================="
		  #     echo "Speglar till Dropbox:"
		  #     echo "=========================================================="
		  #     /usr/bin/rsync -hlrtvz --progress --delete $Source $Dropbox
		  #     Dropbox_Success=1; 
		  # else
		  #     echo "=========================================================="
		  #     echo "Dropbox är ej monterad, synkar ej denna."
		  #     echo "=========================================================="
		  #     Dropbox_Success=0
		  # fi
	    	  # break;;
    esac
done

echo "Dokument, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), Dropbox ($Dropbox_Success)" >> ~/Backup_dates_disks.txt

#echo "Dokument, "`date` "till NAS ($Nas_Success), OneTB_ntfs ($OneTB_ntfs_Success), ExtDiskTwo ($ExtDiskTwo_Success), Dropbox ($Dropbox_Success)" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo " $Source till $Target: $Nas_Success"
echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
#echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo "=========================================================="
