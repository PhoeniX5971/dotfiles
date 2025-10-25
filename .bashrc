#    _               _
#   | |__   __ _ ___| |__  _ __ ___
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__
# (_)_.__/ \__,_|___/_| |_|_|  \___|
#
# -----------------------------------------------------
# ML4W bashrc loader
# -----------------------------------------------------

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/bashrc
# or by creating a folder ~/.config/bashrc/custom
# with copies of files from ~/.config/bashrc
# You can also create a .bashrc_custom file in your home directory
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configarion
# -----------------------------------------------------
#
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

for f in ~/.config/bashrc/*; do
	if [ ! -d $f ]; then
		c=$(echo $f | sed -e "s=.config/bashrc=.config/bashrc/custom=")
		[[ -f $c ]] && source $c || source $f
	fi
done

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------

if [ -f ~/.bashrc_custom ]; then
	source ~/.bashrc_custom
fi

# Created by `pipx` on 2025-03-09 17:21:41
export PATH="$PATH:/home/phoenix/.local/bin"
