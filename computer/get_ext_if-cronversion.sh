#!/bin/bash
#
# Namnger textfil:
ipFile=$HOME/ext_ip.txt
writtenIP="`cat $ipFile`"

# Få tag i den externa adressen:
checkedIP="`curl http://ipinfo.io/ip`"> /dev/null 2>&1
#echo $checkedIP

# Jämför om nuvarande extern adress är samma som i textfilen.
# Om de stämmer överens, gör inget. Om inte, så skickas ett mail mha mutt.
if [ "$writtenIP" =  "$checkedIP" ]; then
#    /usr/bin/notify-send $checkedIP
    exit 0
    #echo "Programmet avslutas nu."
else
#    echo $checkedIP > $ipFile
#    /usr/bin/notify-send $checkedIP
    /usr/bin/mutt -s "External ip has changed" johan@birkagatan.com < $ipFile
fi
