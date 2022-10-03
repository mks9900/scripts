#!/bin/zsh

cd /home/johanthor/program/emacs-git-code

echo "\nUpdating emacs..."
git pull

echo "\nConfiguring emacs..."
./configure --with-pgtk --prefix=/home/johanthor/program/emacs

echo "\nBuilding emacs..."
make -j8

echo "\nInstalling emacs..."
make install

cd

echo "Done!"

