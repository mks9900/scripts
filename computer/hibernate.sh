#!/bin/bash
Question=`/usr/bin/zenity --question --text="Vill du försätta datorn i viloläge?" --ok-label="Ja, tack." --cancel-label="Nej, tack"; echo $?`
if [ "$Question" = 0 ]; then 
    sudo "/usr/sbin/pm-hibernate"
else
    :
fi
