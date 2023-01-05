#!/bin/bash
Question=`/usr/bin/zenity --question --text="Vill du logga ut från fluxbox?" --ok-label="Ja, tack." --cancel-label="Nej, tack"; echo $?`
if [ "$Question" = 0 ]; then 
    /usr/bin/fluxbox --exit
else
    :
fi
