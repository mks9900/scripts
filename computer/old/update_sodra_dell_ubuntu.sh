#!/bin/zsh

echo "\n### Updating oh-my-zsh:"
cd ~/.oh-my-zsh/
/usr/bin/git pull --quiet

echo "\n### Updating powerlevel10k-theme:"
cd ~/.oh-my-zsh/custom/themes/powerlevel10k
/usr/bin/git pull --quiet

echo "\n### Updating pyenv:"
cd ~/.pyenv/
/usr/bin/git pull --quiet

echo "\n### Updating pyenv-virtualenv:"
cd ~/.pyenv/plugins/pyenv-virtualenv
/usr/bin/git pull --quiet
cd ~

echo "\n### apt upgrade:"
sudo apt -qq update
sudo apt upgrade

echo "\n### apt autoremove:"
sudo apt autoremove -y

echo "\n### Snap refresh:"
sudo snap refresh

echo "\n### Flatpak update:"
sudo flatpak update

echo "\n### Updating brew:"
brew update --quiet
brew upgrade
brew cleanup

echo "\n### Update firmware"
sudo fwupdmgr update --force

echo "\n### Done updating!"
