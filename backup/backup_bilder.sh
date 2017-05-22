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
Lacie1TBase=/media/LACIE1TB/backup
ExtDiskTwoBase=/media/backup-ext/backup

#echo "Vilket år vill du säkerhetskopiera?"
#select svar in  Allt 2001 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016; do
#    case $svar in
#               Allt ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$AllPath"; NgNas="$NgNasBase"; Lacie1T="$Lacie1TBase"; ExtDiskTwo="$ExtDiskTwoBase"; break;;
#        2001 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2004 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2005 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#       2006 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#        2007 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2008 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2009 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2010 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2011 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2012 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2013 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2014 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2015 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#	2016 ) echo "Ok, säkerhetskopierar år $svar."; Source="$SourceBase""/""$YearPath""/""$svar"; NgNas="$NgNasBase""/""$YearPath""/""$svar"; Lacie1T="$Lacie1TBase""/""$YearPath""/""$svar";  ExtDiskTwo="$ExtDiskTwoBase""/""$YearPath""/""$svar"; break;;
#    esac
#done

Source="$SourceBase""/""$AllPath"
NgNas="$NgNasBase"
Lacie1T="$Lacie1TBase"
ExtDiskTwo="$ExtDiskTwoBase"

echo "Till vilken enhet vill du säkerhetskopiera?"
select enhet in Alla NAS Lacie1T ExtDiskTwo; do
    case $enhet in
	Alla ) echo "Speglar till NAS, Lacie1T och ExtDiskTwo";
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
	       # Synka sedan till Lacie1Tb om den är monterad, annars avbryt:
	       if [ -d "$Lacie1T" ]; then
		   echo "=========================================================="
		   echo "Speglar till Lacie 1 Tb:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $Lacie1T
		   Lacie1T_Success=1; 
	       else
		   echo "Lacie1Tb-disken är ej monterad, synkar ej denna."
		   Lacie1T_Success=0;
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
	       
	       break;;
	
	NAS ) echo "Speglar till NAS:en.";
	      # Synka till ng-nas om den är monterad, annars avbryt:
	      if [ "$DevSource" = "$TRY" ]; then
		  /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $NgNas
		  echo $Source/
		  echo $NgNas/
		  Nas_Success=1; 
	      else
		  echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		  Nas_Success=0;
	      fi
	      break;;
	
	Lacie1T ) echo "Speglar till Lacie1Tb.";
		  # Synka till Lacie1Tb om den är monterad, annars avbryt:
		  if [ -d "$Lacie1T" ]; then
		      echo "=========================================================="
		      echo "Speglar till Lacie 1 Tb:"
		      echo "=========================================================="
		      /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --delete $Source $Lacie1T
		      Lacie1T_Success=1; 
		  else
		      echo "Lacie1Tb-disken är ej monterad, synkar ej denna."
		      Lacie1T_Success=0;
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
    esac
done

echo "Backup av bilderna kördes" `date` " till $enhet" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo 
echo " $Source till $NgNas: $Nas_Success"
echo " $Source till $Lacie1T: $Lacie1T_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo "=========================================================="
