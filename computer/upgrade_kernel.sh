#!/bin/bash
#
echo "Följande kärna är vald:"
eselect kernel list

echo "Vill du kopiera den gamla konfig-filen till den nya kärnan?"
select copy_old_config in Ja Nej; do
    case $copy_old_config in
	Ja ) # Hittar valt namn på nuvarande kärna:
	     CurrentKernelVersion=`eselect kernel list|grep \*|awk '{print $2}'`
	     #echo "Version="$Version
	     PathCurrentKernel=/usr/src/$CurrentKernelVersion/
	     #Byter till ny kärna:
	     echo "Vilken kärna vill du välja?"
	     #eselect kernel list
	     read svar
	     sudo eselect kernel set $svar
	     # Hittar valt namn på nyvalda kärnan:
	     NewKernelVersion=`eselect kernel list|grep \*|awk '{print $2}'`
	     PathNewKernel=/usr/src/$NewKernelVersion/
	     #Kopierar gamla profilen till den nya (ny symlink ej satt än):
	     sudo /bin/cp $PathCurrentKernel/.config $PathNewKernel
	     break;;
	Nej ) echo "Vilken kärna vill du välja?";
	      eselect kernel list
	      read svar
	      sudo eselect kernel set $svar
	      break;;
    esac
done

# Kompilerar kärnan
echo "Vill du köra menuconfig?"
select menucfg in Ja Nej; do
    case $menucfg in
	Ja ) echo "Ok, kör --menuconfig.";
	     sudo genkernel all --menuconfig
	     break;;
	Nej ) echo "Ok, kör på --no-menuconfig."
	      sudo genkernel all --no-menuconfig
	      break;;
    esac
done

#Installerar kärnan i /boot
echo "Installerar nybyggda kärnan i /boot:"
sudo grub-mkconfig -o /boot/grub/grub.cfg

#Ominstallerar nvidia-drivers och vmware-modules med nya kärnan
sudo emerge -av nvidia-drivers #vmware-modules

#Ominstallerar skrivardrivrutinen med nya kärnan
sudo /usr/bin/hp-plugin -i

#Ska datorn startas om nu eller ej?
echo "Vill du starta om datorn?"
select reboot in  Ja Nej; do
    case $reboot in
	Ja ) echo "Ok, STARTAR OM NU!"; sudo /sbin/reboot;break;;
	Nej ) echo "Ok, du får manuellt starta om senare";break;;
    esac
done
