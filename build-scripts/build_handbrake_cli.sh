#!/bin/zsh



echo "\n### Updating Handbrake:"
cd ~/program/HandBrake
/usr/bin/git pull --quiet

# backing up old build folder:
mv build/ build-old

./configure --enable-x265 --enable-x264 --enable-fdk-aac --enable-nvenc --disable-gtk --enable-numa

cd build

make

# ln -s HandBrakeCLI ~/bin/

rm -rf /home/johanthor/program/HandBrake/build-old

echo "\n### Done updating!"

