function gedit
{
  command gedit "$@" &
}

function mkdir
{
  command mkdir $1 && cd $1
}

function goto
{
  path="$(find . -type f -name $1)"
  if [ -z "$path" ]; then
    echo "No file with given name can be found"
  else
    cd "$(dirname "$path")"
    ls
  fi	
}

function show
{
  path="$(find . -type f -name $1)"
  if [ -z "$path" ]; then
    echo "No file with given name can be found"
  else
    less "$path"
  fi
}

function showa
{
    git alias | grep $1
	alias | grep $1
}
