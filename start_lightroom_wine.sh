#!/bin/bash
wine_folder=/home/johan/.wine/drive_c
lr_folder=Program\ Files/Adobe/Adobe\ Photoshop\ Lightroom\ 5.7
lr_exec=lightroom.exe
wine_exec=/usr/bin/wine
#exec lightroom
$wine_exec "$wine_folder"/"$lr_folder"/$lr_exec
