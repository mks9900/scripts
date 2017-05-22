#!/bin/bash

oldIP="`curl http://ipinfo.io/ip`" > /dev/null 2>&1
/usr/bin/sudo /etc/init.d/openvpn start

newIP="`curl http://ipinfo.io/ip`" > /dev/null 2>&1

while [ "$oldIP" == "$newIP" ]; do
    sleep 1
    newIP="`curl http://ipinfo.io/ip`" > /dev/null 2>&1
    if [ "$oldIP" != "$newIP" ]; then
	/usr/bin/notify-send -i $HOME/.icons/openvpn.png "$(echo -e "VPN uppkopplad. \n\nGammal IP: $oldIP \nNy IP: $newIP")"
	break;
    else
	sleep 1
    fi
done
