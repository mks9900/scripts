#!/bin/zsh

echo "\n### Updating repos in ~/themes/gtk:"
cd ~/code/themes/WhiteSur-gtk-theme
/usr/bin/git pull --quiet

echo "\n### Installing updated gtk theme:"
# --theme = theme accent, "black" = dark mode
# ./install.sh --theme red -c --black
<<<<<<< HEAD
./install.sh --theme red --theme blue --icon ubuntu

echo "\n### Installing updated firefox theme:"
# ./tweak.sh
./tweaks.sh -f monterey
=======
./install.sh --theme red --theme blue --icon ubuntu --libadwaita

echo "\n### Installing updated firefox theme:"
# ./tweak.sh
./tweaks.sh -f
>>>>>>> f49b0b681c3557265c638f1109d941926c95f005

echo "\n### Installing updated flatpak theme:"
./tweaks.sh -F

echo "\n### Installing updated snap theme:"
./tweaks.sh -s

#
#

echo "\n### Updating repos in ~/code/themes/icons:"
cd ~/code/themes/WhiteSur-icon-theme
/usr/bin/git pull --quiet

echo "\n### Installing updated icon theme:"
# --theme = theme accent, "black" = dark mode
# ./install.sh --theme red -c --black
<<<<<<< HEAD
./install.sh --theme red --theme grey --bold
=======
./install.sh --theme red --theme grey
>>>>>>> f49b0b681c3557265c638f1109d941926c95f005

echo "\n### Done updating!"
