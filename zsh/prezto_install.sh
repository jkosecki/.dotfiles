#!/usr/bin/env zsh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

which git > /dev/null
if (($?)); then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    for custom_rcfile in "${DIR}"/^README.MD(.N); do
        ln -sf "$custom_rcfile" "${ZDOTDIR:-$HOME}/.${custom_rcfile:t}"
    done
else
    echo_err red "GIT is not installed. Can't continue with Prezto installation"
fi