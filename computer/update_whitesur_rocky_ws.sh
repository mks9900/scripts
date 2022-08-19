#!/bin/zsh

echo "\n### Updating repos in ~/themes/gtk:"
cd ~/themes/WhiteSur-gtk-theme
/usr/bin/git pull --quiet

echo "\n### Installing updated gtk theme:"
# --theme = theme accent, "black" = dark mode
# ./install.sh --theme red -c --black

./install.sh -c dark -c light --theme red --theme blue --theme green --icon ubuntu

echo "\n### Installing updated firefox theme, flatpak and snap:"
# ./tweak.sh
./tweaks.sh --flatpak --firefox --snap --background default --color dark --theme red 

./install.sh --theme red --theme blue --icon ubuntu --libadwaita

echo "\n### Installing updated firefox theme, flatpak and snap:"
# ./tweak.sh
./tweaks.sh --flatpak --firefox --snap --background default --theme red 

#
#

echo "\n### Updating repos in ~/themes/icons:"
cd ~/themes/WhiteSur-icon-theme
/usr/bin/git pull --quiet

echo "\n### Installing updated icon theme:"
# --theme = theme accent, "black" = dark mode
# ./install.sh --theme red -c --black

./install.sh --theme red --theme red --theme green --theme purple --theme orange --bold

./install.sh --theme red --theme red --bold


echo "\n### Done updating!"
