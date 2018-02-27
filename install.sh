#!/usr/bin/env bash

enable_colors=1


echo_err_color() {
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

echo_err_no_color() {
	if (( $enable_colors )); then
		echo -ne "\e[0m" >&2;
	fi
}

echo_err() { 
	if [ $# -gt 1 ]; then
		color=$1
		shift
		echo_err_color $color
	fi
	echo "$@" >&2;
	if [ $color ]; then
		echo_err_no_color
	fi
}

printf_err() { 
    printf "$@" >&2; 
}

get_yes_no_answer() {
    while true; do
        read -p "$1 (Y/n): " answer
        if [ -z "$answer" ]; then
            answer="y"
        fi
        case "$answer" in
            Y*|y*)
                return 0
                ;;
            N*|n*)
                return 1
                ;;
            *)
                echo_err red "Answer bot understood: ${answer}"
                ;;
        esac
    done
}

simple_installation()
{
    which $1 > /dev/null
    if (($?)); then
        echo_err darkcyan "$2 is not installed in the system"
        if (get_yes_no_answer "Do you want to install it"); then
            if [ -z "$3" ]; then
                sudo apt -y install $1
            else
                sudo apt -y install $3    
            fi
        fi
    fi
}

parse_arguments()
{
    while [ $# -ne 0 ]; do
        case "$1" in
            --no-colors)
                enable_colors=0
                echo_err darkcyan "Colors disabled"
                ;;
            --interactive)
                enable_interactive=1
                echo_err darkcyan "Interactive mode enabled"
                ;;
            *)
                echo_err red "Unfamiliar configuration option $1"
        esac
        shift
    done
}

install_vscode()
{
    which code > /dev/null
    if (($?)); then
        echo_err darkcyan "VSCode is not installed in the system"
        if (get_yes_no_answer "Do you want to install it"); then
            echo_err green "Installing VSCode"
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
            sudo apt update && sudo apt -y install code
        else
            echo_err darkgreen "VSCode won't be installed"
        fi
    fi  
}

install_python()
{
    simple_installation python2 "Python2"
    simple_installation python3 "Python3"
    simple_installation pip "PIP for Python2" python-pip
    simple_installation pip3 "PIP for Python3" python3-pi
}

dconf_path="~/.dotfiles/dconf"

install_tilix()
{
    which tilix >>/dev/null
    if (($?)); then
        echo_err darkcyan "Tilix is not installed in the system"
        if (get_yes_no_answer "Do you want to install it"); then
            sudo add-apt-repository -y ppa:webupd8team/terminix
            sudo apt update && sudo apt -y install tilix
            local tilix_conf="$dconf_path/tilix.dconf"
            if [[ -f "$tilix_conf" ]]
                dconf load /com/gexperts/Tilix/ < "$tilix_conf"
            fi
        else
            echo_err darkgreen "Tilix won't be installed"
        fi
    fi
}

apply_dconf()
{
    echo_err darkcyan "Applying saved dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ < "$dconf_path/custom_shortcuts.dconf"
    dconf load /org/gnome/desktop/wm/ < "$dconf_path/wm.dconf"
}

install_vscode
install_python
install_tilix
apply_dconf
