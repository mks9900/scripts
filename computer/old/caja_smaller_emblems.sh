#!/bin/bash
temp=$(mktemp -d)
pushd "$temp"
mkdir 16x16
cp /usr/share/caja/icons/hicolor/64x64/emblems/emblem-insync* .
for emblem in $(ls *.png); do
  convert "$emblem" -resize 16x16 16x16/"$emblem"
done
sudo cp 16x16/* /usr/share/caja/icons/hicolor/16x16/emblems/
sudo gtk-update-icon-cache /usr/share/icons/hicolor
popd
rm -r "$temp"
