#!/bin/bash

# För att ladda ner diverse program:
mkdir $HOME/tmp
mkdir $HOME/tmp-install
mkdir $HOME/.icons
mkdir -p /home/johan/.config/RawTherapee5-dev

# Emacs och mate-desktop installeras nedan så att vi kan välja dem som editor och default terminal:
sudo apt install emacs mate-desktop-environment
sudo update-alternatives --config editor
sudo update-alternatives --config x-terminal-emulator

# Kopiera manuellt in nedanstående utan #
sudo visudo
# johan ALL = NOPASSWD: /usr/bin/apt
# johan ALL = NOPASSWD: /usr/bin/apt-get
# johan ALL = NOPASSWD: /usr/bin/apt-cache
# johan ALL = NOPASSWD: /usr/bin/emacs
# johan ALL = NOPASSWD: /usr/bin/add-apt-repository
# johan ALL = NOPASSWD: /bin/mount
# johan ALL = NOPASSWD: /bin/umount
# johan ALL = NOPASSWD: /bin/systemctl
# johan ALL = NOPASSWD: /sbin/blkid
# johan ALL = NOPASSWD: /usr/bin/updatedb
# johan ALL = NOPASSWD: /usr/bin/update-alternatives
# johan ALL = NOPASSWD: /usr/bin/snap
# johan ALL = NOPASSWD: /usr/bin/pip3

# Modifiera /etc/fstab:


# Insync:
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
# sudo touch /etc/apt/sources.list.d/insync.list
# sudo echo "http://apt.insynchq.com/ubuntu artful non-free contrib" > /etc/apt/sources.list.d/insync.list

# Lägg till repo för: rawtherapee-unstable gimp-edge, arc och paper:
sudo add-apt-repository -y ppa:dhor/myway
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp-edge
sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:snwh/pulp
sudo add-apt-repository -y ppa:yg-jensge/shotwell-unstable
sudo add-apt-repository -y ppa:geary-team/releases

# Installera Ubuntu-packages:
# Maple behöver lsb-base och lsb-core för att kunna aktivera sig!
sudo apt update
sudo apt install geeqie gimp-edge gimp-gmic mozo rawtherapee-unstable cifs-utils git texlive-lang-european texlive-bibtex-extra texlive-latex-extra texlive-fonts-extra texlive-xetex texlive-science hunspell-sv hyphen-sv texmaker libreoffice-help-sv mythes-sv hunspell caja-dropbox trash-cli tint2 openbox numlockx conky screengrab lxappearance gmrun feh suckless-tools lm-sensors gnome-raw-thumbnailer filezilla-theme-papirus ssh

# För skrivaren:
# hplip hplip-gui hplip-data hplip-doc hpijs-ppds libsane-hpaio printer-driver-hpcups printer-driver-hpijs

# De två paketen python-pkg-resources python-setuptools behövs för Apples CoreML.

# Avinstallera lite program:
sudo apt remove chromium-browser 

# Installera Cuda från nvidia: https://developer.nvidia.com/cuda-downloads

# Installera Python modules:
# Att installera tensorflow för GPU kräver lite annat. Se googles instruktioner.
# pip3 install spyder pydotplus graphviz numpy scikit-learn scipy matplotlib python-language-server jupyter-core ipython tensorflow statsmodels seaborn sympy keras opencv-python mkl turicreate xgboost wordcloud pillow virtualenv virtualenvwrapper

# Ladda ner från respektive hemsida:
# dropbox 

# copy host-entries:
sudo echo "192.168.1.240 rocky" >> /etc/hosts
sudo echo "192.168.1.104 ng-nas" >> /etc/hosts
sudo echo "192.168.1.1 router" >> /etc/hosts

# På share installation @ng-nas: matlab, mathematica & maple
cd ~ /tmp
sudo mount -t cifs //ng-nas/installation /home/johan/tmp -o username=johan,credentials=/home/johan/.smbcredentials,uid=1000,sec=ntlm,vers=1.0

# Modifiera efter behov:
# rsync -hlrtvz /home/johan/tmp/Matlab /home/johan/tmp-install
# rsync -hlrtvz /home/johan/tmp/Waterloo_MapleMaple_2016_Linux /home/johan/tmp-install
# rsync -hlrtvz /home/johan/tmp/Wolfram_Mathematica/Mathematica_11_Linux /home/johan/tmp-install

# Installera sedan dessa i tur och ordning.

# skapa ssh-nycklar;
# 2048 bit
ssh-keygen -t rsa 

# 4096 bit
# ssh-keygen -t rsa -b 4096
# Kopiera till rocky:
ssh-copy-id -p32113 johan@rocky

# Kopiera dot-filer från rocky:
cd ~
scp -P32113 johan@rocky:/home/johan/.emacs .
scp -P32113 -r johan@rocky:/home/johan/.config/RawTherapee5-dev/* ~/.config/
scp -P32113 -r johan@rocky:/home/johan/.icons/* ~/.icons/

# Byt ut bashrc mot den som finns på rocky:
rm -f $HOME/.bashrc
scp -P32113 johan@rocky:/home/johan/.bashrc .
