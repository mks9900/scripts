#!/bin/bash

if [ -f /var/run/openvpn.pid ]; then
    Question=`/usr/bin/zenity --question --text="VPN startad. \nVill du stoppa tjänsten?" --ok-label="Ja" --cancel-label="Nej"; echo $?`
    if [ "$Question" = 0 ]; then 
        /home/johan/scripts-gentoo/computer/./vpn-down.sh
    else
        :
    fi
else
    Question=`/usr/bin/zenity --question --text="VPN ej startad: Du är ej anonym! \nVill du starta tjänsten?" --ok-label="Ja" --cancel-label="Nej"; echo $?`
    if [ "$Question" = 0 ]; then 
        /home/johan/scripts-gentoo/computer/./vpn-up.sh
    else
        :
    fi
fi

