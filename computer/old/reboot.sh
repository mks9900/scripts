#!/bin/bash
Question=`/usr/bin/zenity --question --text="Vill du verkligen starta om datorn?" --ok-label="Ja, tack." --cancel-label="Nej, tack"; echo $?`
if [ "$Question" = 0 ]; then 
    sudo /sbin/shutdown -rf now
else
    :
fi
