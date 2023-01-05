#!/bin/bash
Question=`/usr/bin/zenity --question --text="Vill du verkligen stänga av datorn?" --ok-label="Ja, tack" --cancel-label="Nej, nu blev det fel! Förlåt."; echo $?`
if [ "$Question" = 0 ]; then 
    sudo /sbin/shutdown -h now
else
    :
fi
