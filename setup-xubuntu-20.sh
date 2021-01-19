#!/bin/bash

set -e

dir_script="$(pwd)"
dir_3p="$HOME/code/3p"
downloads="$HOME/Downloads"

sudo apt-get remove -y xubuntu-desktop xfdesktop4

sudo apt-get install -y \
    git \
    vim vim-airline vim-pathogen \
    awesome awesome-extra \
    rxvt-unicode \
    xcompmgr \
    conky-all \
    tmux \
    zsh \
    fonts-powerline \
    xbacklight \
    pulseaudio-utils \
    feh \
    thunar thunar-archive-plugin thunar-volman thunar-media-tags-plugin thunar-vcs-plugin \
    zathura zathura-pdf-poppler


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

echo "DONE!"

