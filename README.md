# dotfiles

These dotfiles contain work done by [Sinomor](https://github.com/Sinomor), [ML4W](https://gitlab.com/stephan-raabe/dotfiles), [refact0r](https://github.com/refact0r/system24), [spicetify](https://github.com/spicetify/spicetify-themes/tree/master/text).

## Install

For arch linux install dependencies with:

```bash
sudo pacman -Syu feh xclip gpick xorg-xrdb picom polkit-gnome \ fontconfig imagemagick zbar slop shotgun flameshot playerctl \ brightnessctl python3 xsettingsd ttf-nerd-fonts-symbols
```

You also need the awesome-git package, which can be downloaded from the AUR. Assuming you are using the "yay" AUR helper:

```bash
yay -Syu awesome-git
```

> Make sure you get the awesome-git version and not the one from pacman.

Clone the repo:

```bash
git clone --depth=1 --recursive https://github.com/PhoeniX5971/dotfiles.git
```

Move everything to it's place.

> Make sure to back up and remove your existing configuration before running the following command

```bash
cd dotfiles
cp -r Thunar/ Vencord/ alacritty/ awesome/ btop/ cava/ flameshot/ kitty/ \
login/ neofetch/ nvim/ rofi/ sddm/ spicetify/ starship/ swappy/ wal/ ~/.config/
mkdir -p ~/Code/Python/scripts/scripts
cp scripts/themeswitcher.py ~/Code/Python/scripts/theme_switcher.py
cp .bashrc ~/.bashrc
```

Now reboot and login into awesome and everything should hopefully work.

> IMPORTANT NOTE: The current color scheme generator for the terminal is using the .config/.awesome/scripts/theme/{colorscheme} which uses a predefined wallpaper, you should change those to wallpaper of your own to work.
