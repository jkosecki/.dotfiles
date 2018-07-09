#!/usr/bin/env zsh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo_err() {
	if (( $enable_colors )); then
		case $1 in
			none)
				col="\e[0;37m"
				;;
			green)
				col="\e[0;32m"
				;;
			red)
				col="\e[0;31m"
				;;
			blue)
				col="\e[1;34m"
				;;
			darkcyan)
				col="\e[0;36m"
				;;
			darkgreen)
				col="\e[1;32m"
				;;
			darkred)
				col="\e[1;31m"
				;;
			magenta)
				col="\e[0;35m"
				;;
			darkmagenta)
				col="\e[1;35m"
				;;
		esac
		echo -ne $col >&2;
	fi
}
echo_err red "Bla bla"


which git > /dev/null
if (($?)); then
    echo_err red "GIT is not installed. Can't continue with Prezto installation"
else
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    for custom_rcfile in "${DIR}"/^README.MD(.N); do
        ln -sf "$custom_rcfile" "${ZDOTDIR:-$HOME}/.${custom_rcfile:t}"
    done
fi