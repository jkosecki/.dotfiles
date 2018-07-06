#!/usr/bin/env bash

enable_colors=1


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dconf_path="$DIR/dconf"
git_template_path="$DIR/templates/gitconfig.tpl"
git_config_template_paht="$DIR/templates/git_ssh_config.tpl"

echo $DIR
echo $dconf_path
echo $git_template_path


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
                echo_err red "Answer not understood: ${answer}"
                ;;
        esac
    done
}

get_answer() {
    if [ -z "$2" ]; then
        read -p "$1: " answer
    else
        read -p "$1 ($2): " answer
    fi
    if [ -z "$answer" ]; then
        answer=$2
    fi
    echo $answer
}

get_answer_with_confirmation()
{
    read -p "$1" str_answer

    while ! get_yes_no_answer "$2 \"$str_answer\""; do
        read -p "$1" str_answer
    done
    echo $str_answer
}

fix_path()
{
    var=$1
    path="${var/#\~/$HOME}"
    case $path in
        /*) 
          path=$path
          ;;
        ./*)
          path=$PWD/${path#./}
          ;;
        *)
          path=$PWD/$path
          ;;
    esac
    echo $path
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
            return 1
        else
            return 0
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
            sudo apt install curl >> /dev/null
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
    simple_installation python "Python2"
    simple_installation python3 "Python3"
    simple_installation pip "PIP for Python2" python-pip
    simple_installation pip3 "PIP for Python3" python3-pip
    if (($?)); then
        local libraries="setuptools wheel pipenv virtualenv"
        echo_err darkcyan "Installing PIP3 libraries $libraries in user scope"
        pip3 install --user $libraries
        echo_err darkcyan "Libraries installed"
    fi
}


install_tilix()
{
    which tilix > /dev/null
    if (($?)); then
        echo_err darkcyan "Tilix is not installed in the system"
        if (get_yes_no_answer "Do you want to install it"); then
            sudo add-apt-repository -y ppa:webupd8team/terminix
            sudo apt update && sudo apt -y install tilix
            local tilix_conf="$dconf_path/tilix.dconf"
            if [[ -f "$tilix_conf" ]]; then
                dconf load /com/gexperts/Tilix/ < "$tilix_conf"
            fi
        else
            echo_err darkgreen "Tilix won't be installed"
        fi
    fi
}

install_java()
{
    if (get_yes_no_answer "Do you want to install Java9"); then
            sudo add-apt-repository ppa:webupd8team/java
            sudo apt-get update
            sudo apt-get install oracle-java9-installer
        else
            echo_err darkgreen "Java9 won't be installed"
        fi
}


apply_dconf()
{
    echo_err darkcyan "Applying saved dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ < "$dconf_path/custom_shortcuts.dconf"
    dconf load /org/gnome/desktop/wm/ < "$dconf_path/wm.dconf"
    dconf load /org/gnome/shell/extensions/TaskBar/ < "$dconf_path/taskbar.dconf"
}

install_git()
{
    which git > /dev/null
    if (($?)); then
        echo_err darkcyan "Git is not installed in the system"
        if ( get_yes_no_answer "Do you want to install it"); then
            sudo apt install git
        else
            echo_err darkgreen "Git won't be installed"
        fi
    fi

    local gitconfig_path=~/.gitconfig
    if ( get_yes_no_answer "Do you want to copy GIT config?"); then
        local copy=0
        if [ -f $gitconfig ]; then
            get_yes_no_answer "$gitconfig_path already exist. Override?"
            copy=$?
        fi

        if ((!$copy)); then
            if cp -f "$git_template_path" "$gitconfig_path"; then
                username=`get_answer_with_confirmation "GIT username: " "Your GIT username is"`
                email=`get_answer_with_confirmation "GIT email: " "Your GIT email is"`

                sed -i s/\${name}/$username/g $gitconfig_path
                sed -i s/\${email}/$email/g $gitconfig_path
            fi
        fi
    fi

    if get_yes_no_answer "Do you want to generete a new SSH key?"; then
        local path=$(get_answer "Enter file in which to save the key" ~/.ssh/github2/id_rsa)
        local path=$(fix_path $path)
        local dir_path=$(dirname $path)
            
        if [ ! -d "$dir_path" ]; then
            mkdir -p "$dir_path"
        fi

        local email=$(get_answer "E-mail" $email)
        ssh-keygen -t rsa -b 4096 -C $email -f $path

        ssh-add $path

        if get_yes_no_answer "Do you want to add the key to SSH config?"; then
            if [ ! -d "$HOME/.ssh" ]; then
                mkdir -p "$HOME/.ssh"
            fi
            if [ ! -f "$HOME/.ssh/config" ]; then
                touch "$HOME/.ssh/config"
            fi

            cat "$git_config_template_paht" | sed s/\${github_key_path}/$path/g >> "$HOME/.ssh/config"
        fi

        if get_yes_no_answer "Do you want to upload the key to GitHub?"; then
            local key_title=$(uname -n)
            local username=$(get_answer "GitHub username" $username)
            local key_title=$(get_answer "Key title" $key_title)
            
            curl -u $username --data "{'title':'$key_title','key':'`cat $path`'}" https://api.github.com/user/keys
        fi
    fi
}

install_git

run()
{
    install_vscode
    install_python
    install_tilix
    apply_dconf
}

show_colors()
{
    echo_err none Hello
    echo_err green Hello
    echo_err red Hello
    echo_err blue Hello
    echo_err darkcyan Hello
    echo_err darkgreen Hello
    echo_err darkred Hello
    echo_err magenta Hello
    echo_err darkmagenta Hello
}