#!/bin/zsh

# i varje env finns lib/python*/site-packages finns filer som ska rensas med jämna
# mellanrum.

set -e

Target=/opt/anaconda3/envs

cd $Target

echo "Beräknar storleken på disk innan rensning...\n"

diskusage_before="$(du -chs .|awk '{print $1;exit}')" # exit gör att vi fångar en rad; du spottar ur sig två rader...


for TempDir in *; do
    #echo $TempDir
    cd $TempDir/lib/python*/site-packages
    pwd
    echo "Nu sudo rm -rf *!\n"
    #pwd
    cd ../../../../
    #pwd

done

echo "Beräknar storleken på disk efter rensning...\n"
diskusage_after="$(du -chs .|awk '{print $1;exit}')"


echo "Före:" $diskusage_before "och" $diskusage_after "efter rensning!"
