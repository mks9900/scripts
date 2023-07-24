#!/bin/zsh

echo "\n### Updating oh-my-zsh:"
cd ~/.oh-my-zsh/
/usr/bin/git pull --quiet

echo "\n### Updating powerlevel10k-theme:"
cd ~/.oh-my-zsh/custom/themes/powerlevel10k
/usr/bin/git pull --quiet

# echo "\n### Updating pyenv:"
# cd ~/.pyenv/
# /usr/bin/git pull --quiet

# echo "\n### Updating pyenv-virtualenv:"
# cd ~/.pyenv/plugins/pyenv-virtualenv
# /usr/bin/git pull --quiet
# cd ~

echo "\n### Updating brew:"
brew update --quiet
brew upgrade
brew cleanup

echo "\n### OS upgrades:"
/usr/sbin/softwareupdate --all --list

echo "\n### Done updating!"
