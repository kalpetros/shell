#!/bin/sh

GREEN=$(printf '\033[32m')
DEFAULT=$(printf '\033[m')

command_exists() {
    command -v "${@}" >/dev/null 2>&1
}

setup_bash() {
    echo "${GREEN}Setting up bash...${DEFAULT}"
    mkdir ~/.bash_config
    cp .bash_aliases ~/
    cp git-prompt.sh  ~/.bash_config/
    cp git-completion.bash ~/.bash_config/
    echo "${GREEN}Finished bash setup${DEFAULT}"
}

setup_shell() {
    if [ $(basename "$SHELL") = "zsh" ]; then
	echo "${GREEN}zsh is already your default shell${DEFAULT}"
	return
    fi

    echo "${GREEN}Making zsh your default shell..."
    chsh -s $(which zsh)
}

setup_ohmyzsh() {
    echo "${GREEN}Setting up oh-my-zsh${DEFAULT}"

    if ! command_exists curl; then
	echo "${GREEN}curl is not installed. Please install curl and then run the script again.${DEFAULT}"
	exit 1
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo "${GREEN}Finished oh-my-zsh setup${DEFAULT}"
}

setup_zshrc() {
    echo "${GREEN}Restoring .zshrc...${DEFAULT}"
    cp .zshrc ~/
}

setup_zsh() {
    echo "${GREEN}Setting up zsh...${DEFAULT}"

    if ! command_exists zsh; then
	echo "Installing..."
	sudo apt-get install zsh -qq -y
	echo "Successfully installed $(zsh --version)"
    fi

    setup_shell
    setup_ohmyzsh
    setup_zshrc
    
    echo "${GREEN}Finished zsh setup${DEFAULT}"
    echo "${GREEN}Log out from your user session and log back in to use zsh.${DEFAULT}"
}

setup_tmux() {
    echo "${GREEN}Setting up tmux...${DEFAULT}"

    if ! command_exists tmux; then
	echo "${GREEN}Installing...${DEFAULT}"
	sudo apt-get install tmux -qq -y
	echo "${GREEN}Successfully installed $(tmux -V)${DEFAULT}"
    fi

    echo "${GREEN}tmux setup is complete.${DEFAULT}"
}

setup_tmuxinator() {
    echo "${GREEN}Setting up tmuxinator...${DEFAULT}"

    if ! command_exists tmuxinator; then
	echo "${GREEN}Installing...${DEFAULT}"
	sudo apt-get install tmuxinator -qq -y
	echo "${GREEN}Successfully installed tmuxinator${DEFAULT}"
    fi

    echo "${GREEN}Finished tmuxinator setup${DEFAULT}"
}

setup_bash
setup_zsh
setup_tmux
setup_tmuxinator
