#!/bin/sh

GREEN=$(printf '\033[32m')
RESET=$(printf '\033[m')

command_exists() {
    command -v "${@}" >/dev/null 2>&1
}

setup_bash() {
    echo "${GREEN}Setting up bash...${RESET}"
    mkdir ~/.bash_config
    cp .bash_aliases ~/
    cp git-prompt.sh  ~/.bash_config/
    cp git-completion.bash ~/.bash_config/
    echo "${GREEN}Finished bash setup${RESET}"
}

setup_shell() {
    if [ $(basename "$SHELL") = "zsh" ]; then
	echo "${GREEN}zsh is already your default shell${RESET}"
	return
    fi

    echo "${GREEN}Making zsh your default shell...${RESET}"
    chsh -s $(which zsh)
}

setup_ohmyzsh() {
    echo "${GREEN}Setting up oh-my-zsh${RESET}"

    if ! command_exists curl; then
	echo "${GREEN}curl is not installed. Please install curl and then run the script again.${RESET}"
	exit 1
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo "${GREEN}Finished oh-my-zsh setup${RESET}"
}

setup_zshrc() {
    echo "${GREEN}Restoring .zshrc...${RESET}"
    cp .zshrc ~/
}

setup_zsh() {
    echo "${GREEN}Setting up zsh...${RESET}"

    if ! command_exists zsh; then
	echo "${GREEN}Installing...${RESET}"
	sudo apt-get install zsh -qq -y
	echo "${GREEN}Successfully installed $(zsh --version)${RESET}"
    fi

    setup_shell
    setup_ohmyzsh
    setup_zshrc
    
    echo "${GREEN}Finished zsh setup${RESET}"
    echo "${GREEN}Log out from your user session and log back in to use zsh.${RESET}"
}

setup_tmux() {
    echo "${GREEN}Setting up tmux...${RESET}"

    if ! command_exists tmux; then
	echo "${GREEN}Installing...${RESET}"
	sudo apt-get install tmux -qq -y
	echo "${GREEN}Successfully installed $(tmux -V)${RESET}"
    fi

    echo "${GREEN}tmux setup is complete.${RESET}"
}

setup_tmuxinator() {
    echo "${GREEN}Setting up tmuxinator...${RESET}"

    if ! command_exists tmuxinator; then
	echo "${GREEN}Installing...${RESET}"
	sudo apt-get install tmuxinator -qq -y
	echo "${GREEN}Successfully installed tmuxinator${RESET}"
    fi

    echo "${GREEN}Finished tmuxinator setup${RESET}"
}

setup_bash
setup_zsh
setup_tmux
setup_tmuxinator
