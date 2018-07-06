# opens Visual Studio inside current folder. Forces application to open in existing window
alias vscode='code -r . &' 

# opens vim as sudo user
alias svim='sudo vim'

# upgrades system
alias upgrade='sudo apt update && sudo apt -y upgrade && sudo apt autoremove'

# performs update of sources and installs newest
alias update='sudo apt update && sudo apt install && sudo apt autoremove'

#Opens current directory in a file explorer
alias explore='nautilus . &' 

#Opens current directory in a file explorer with super user privileges
alias suexplore='sudo nautilus . &'


#Opens a file with whatever program would open by double clicking on it in a GUI file explorer
#Usage: try someDocument.doc
alias try='gnome-open'

#self explanatory
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

#show aliases
alias a='echo "------------Your aliases------------";alias'
#Apply changes 
alias sa='source $BASH_FOLDER/.bash_aliases;echo "Bash aliases sourced."'
alias src='source ~/.bashrc;echo "Bashrc sourced"'

alias via='vim $BASH_FOLDER/.bash_aliases'
alias virc='vim $BASH_FOLDER/.bash_common'
alias vigc='vim ~/.gitconfig'


#Projects
alias gogo='cd $(go env GOPATH)/src'

#lists contents of current directory with file permisions
alias ll='ls -l -sort'
#list all directories in current directories
alias ldir='ls -l | grep ^d'
alias exl='exa -lha'

#python
alias pip3_upgrade="pip3 list --outdated --format=freeze | grep -v '^\-e\' | cut -d = -f 1 | xargs -n1 pip3 install -U"
alias pip2_upgrade="pip list --outdated --format=freeze | grep -v '^\-e\' | cut -d = -f 1 | xargs -n1 pip install -U"
