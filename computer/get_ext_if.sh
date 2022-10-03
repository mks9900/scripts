#!/bin/zsh
#
# Namnger textfil:
ipFile=$HOME/pCloudDrive/ext_ip.txt
writtenIP="`cat $ipFile`"

# Få tag i den externa adressen:
checkedIP="`curl http://ipinfo.io/ip`"> /dev/null 2>&1
echo $checkedIP

# Jämför om nuvarande extern adress är samma som i textfilen:
if [ "$writtenIP" =  "$checkedIP" ]; then
    exit 0
else
    echo $checkedIP > $ipFile
fi
