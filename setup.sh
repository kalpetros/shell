#!/bin/sh

command_exists() {
    command -v "${@}" >/dev/null 2>&1
}

setup_ohmyzsh() {
    echo "Setting up oh-my-zsh"
}

setup_zsh() {
    DEFAULT_SHELL=$(echo $SHELL)

    echo "Setting up zsh..."

    if ! command_exists zsh; then
	echo "Installing..."
	sudo apt-get install zsh -qq -y
	echo "Successfully installed $(zsh --version)"
    fi

    if [ $DEFAULT_SHELL != "/bin/zsh" ]; then
	echo "Making zsh your default shell..."
	chsh -s $(which zsh)
    fi

    setup_ohmyzsh

    echo "Restoring .zshrc..."
    cp .zshrc ~/.zshrc
    
    echo "zsh setup is complete! Log out from your user session and log back in to use zsh."
}

setup_tmux() {
    echo "Setting up tmux..."

    if ! command_exists tmux; then
	echo "Installing..."
	sudo apt-get install tmux -qq -y
	echo "Successfully installed $(tmux -V)"
    fi

    echo "Do you want to start tmux automatically on new shell sessions? [y/n]"
    read ANSWER

    if [ $ANSWER = y ]; then
	echo "Yes"
    fi

    echo "tmux setup is complete."
}

setup_tmuxinator() {
    echo "Setting up tmuxinator..."

    if ! command_exists tmuxinator; then
	echo "Installing..."
	sudo apt-get install tmuxinator -qq -y
	echo "Successfully installed tmuxinator"
    fi

    echo "tmuxinator setup is complete."
}

setup_zsh
setup_tmux
setup_tmuxinator
