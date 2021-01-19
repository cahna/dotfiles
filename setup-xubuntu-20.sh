#!/bin/bash

set -e

dir_script="$(pwd)"
dir_3p="$HOME/code/3p"
downloads="$HOME/Downloads"

sudo apt-get remove -y xubuntu-desktop xfdesktop4 xfce4-panel

sudo apt-get install -y \
    git \
    vim vim-airline vim-pathogen \
    awesome awesome-extra \
    rxvt-unicode \
    xcompmgr \
    conky-all \
    tmux \
    zsh \
    xsel \
    fonts-powerline fonts-font-awesome \
    xbacklight \
    pulseaudio-utils \
    feh \
    thunar thunar-archive-plugin thunar-volman thunar-media-tags-plugin thunar-vcs-plugin \
    zathura zathura-pdf-poppler \
    jq \
    htop \
    python3 python3-pip python3-venv


sudo apt-get autoremove -y

##
# Install fonts
##
iosevka_versions=("4.5.0.zip" "term-4.5.0.zip" "fixed-4.5.0.zip")
mkdir -p "$downloads/iosevka"
for v_iosevka in "${iosevka_versions[@]}"; do
    wget --no-clobber -P "$downloads" "https://github.com/be5invis/Iosevka/releases/download/v4.5.0/ttf-iosevka-$v_iosevka"
    unzip -n "$downloads/ttf-iosevka-$v_iosevka" -d "$downloads/iosevka/"
done
sudo cp -rn "$downloads/iosevka" /usr/share/fonts/truetype/
sudo fc-cache -fv

##
# Install user configs
##
mkdir -p "$dir_3p"
[ ! -d "$dir_3p/awesome-copycats" ] && git clone https://github.com/lcpz/awesome-copycats "$dir_3p/awesome-copycats"
[ ! -d "$dir_3p/dotfiles" ] && git clone https://github.com/cahna/dotfiles "$dir_3p/dotfiles"
bash -c "cd '$dir_3p/dotfiles' && git submodule init && git submodule update --recursive"
cp -n "$dir_3p/dotfiles/Xresources" "$HOME/.Xresources"
cp -n "$dir_3p/dotfiles/zshrc" "$HOME/.zshrc"
cp -nr "$dir_3p/dotfiles/vim" "$HOME/.vim"
cp -n "$dir_3p/dotfiles/vimrc" "$HOME/.vimrc"
cp -n "$dir_3p/dotfiles/xinitrc" "$HOME/.xinitrc"
cp -n "$dir_3p/dotfiles/xbindkeysrc" "$HOME/.xbindkeysrc"

##
# Setup AwesomeWM
##
sudo xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -s "awesome" -a

##
# Install VSCodium
##
if [ -z "$(which codium)" ]; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
    echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
    sudo apt update -y
    sudo apt install -y codium
fi

##
# Install Docker
##
if [ -z "$(which docker)" ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
fi

##
# Install Poetry
##
if [ -z "$(which poetry)" ]; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
fi

echo "DONE!"

