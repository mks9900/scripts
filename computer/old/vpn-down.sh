#!/bin/bash
oldIP="`curl http://ipinfo.io/ip`"
wait
/usr/bin/sudo /etc/init.d/openvpn stop
wait

newIP="`curl http://ipinfo.io/ip`"

if [ $? == 0 ]; then
    /usr/bin/notify-send -i $HOME/.icons/openvpn.png "$(echo -e "VPN nerkopplad. \n\nGammal IP: $oldIP \nNy IP: $newIP")"
else
    /usr/bin/notify-send -i $HOME/.icons/openvpn.png "$(echo -e "Kunde ej ta ner VPN! \n\nGammal IP: $oldIP \nNy IP: $newIP")"
fi
