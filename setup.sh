#!/bin/sh

SUCCESS=$(printf '\033[32m')
INFO=$(printf '\033[34m')
WARNING=$(printf '\033[31m')
RESET=$(printf '\033[m')

command_exists() {
    command -v "${@}" >/dev/null 2>&1
}

file_exists() {
    test -f "${@}" >/dev/null 2>&1
}

folder_exists() {
    test -d "${@}" >/dev/null 2>&1
}

setup_tpm() {
    FOLDER=".tmux/plugins/tpm"
    FOLDER_PATH="${HOME}/${FOLDER}"
    
    echo "${INFO}[TPM] Setting up tmux plugin manager...${RESET}"
    
    if ! command_exists git; then
	echo "${WARNING}[TPM] git is not installed. Please install git and then run the script again.${RESET}"
	exit 1
    fi

    if folder_exists "${FOLDER_PATH}"; then
	echo "${WARNING}[TPM] Already exists${RESET}"
    else
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "${SUCCESS}[TPM] Finished setup${RESET}"
    fi
}

setup_bash() {
    FOLDER=".bash_config"
    FOLDER_PATH="${HOME}/${FOLDER}"
    echo "${INFO}[BASH] Setting up...${RESET}"

    if folder_exists "${FOLDER_PATH}"; then
	echo "${WARNING}[BASH] Folder ${FOLDER} already exists${RESET}"
    else
	mkdir ${FOLDER_PATH}
    fi
    
    cp .bash_aliases ~/
    cp git-prompt.sh  ~/.bash_config/
    cp git-completion.bash ~/.bash_config/

    setup_shell "bash"
    
    echo "${SUCCESS}[BASH] Finished setup${RESET}"
}

setup_shell() {
    echo "${INFO}[SHELL] Making ${@} your default shell...${RESET}"
    chsh -s $(which "${@}")
    echo "${INFO}[SHELL] You need to logout and login back again to use "${@}"${RESET}"
}

setup_ohmyzsh() {
    FOLDER=".oh-my-zsh"
    FOLDER_PATH="${HOME}/${FOLDER}"
    echo "${INFO}[OH-MY-ZSH] Setting up...${RESET}"

    if ! command_exists curl; then
	echo "${WARNING}[OH-MY-ZSH] curl is not installed. Please install curl and then run the script again.${RESET}"
	exit 1
    fi

    if folder_exists "${FOLDER_PATH}"; then
	echo "${WARNING}[OH-MY-ZSH] Already exists${RESET}"
    else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	echo "${SUCCESS}[OH-MY-ZSH] Finished setup${RESET}"
    fi
}

setup_zshrc() {
    echo "${INFO}[ZSH] Restoring .zshrc...${RESET}"
    cp .zshrc ~/
    echo "${SUCCESS}[ZSH] Restored .zshrc...${RESET}"
}

setup_zsh() {
    echo "${INFO}[ZSH] Setting up...${RESET}"

    if ! command_exists zsh; then
	echo "${INFO}[ZSH] Installing...${RESET}"
	sudo apt-get install zsh -qq -y
	echo "${SUCCESS}[ZSH] Finished installation $(zsh --version)${RESET}"
	echo "${INFO}[ZSH] Log out from your user session and log back in to use zsh.${RESET}"
    else
	echo "${WARNING}[ZSH] Already installed${RESET}"
    fi

    setup_ohmyzsh
    setup_zshrc
    setup_shell "zsh"

    echo "${SUCCESS}[ZSH] Finished setup${RESET}"
}

setup_tmux() {
    FILE="${HOME}/.tmux.conf"
    echo "${INFO}[TMUX] Setting up...${RESET}"

    if ! command_exists tmux; then
	echo "${INFO}[TMUX] Installing...${RESET}"
	sudo apt-get install tmux -qq -y
	echo "${SUCCESS}[TMUX] Finished instlalation $(tmux -V)${RESET}"
    fi

    setup_tpm
    
    cp .tmux.conf ~/

    echo "${SUCCESS}[TMUX] Finished setup${RESET}"
}

setup_tmuxinator() {
    echo "${INFO}[TMUXINATOR] Setting up...${RESET}"

    if ! command_exists tmuxinator; then
	echo "${INFO}[TMUXINATOR] Installing...${RESET}"
	sudo apt-get install tmuxinator -qq -y
	echo "${SUCCESS}[TMUXINATOR] Finished installation${RESET}"
	echo "${SUCCESS}[TMUXINATOR] Finished setup${RESET}"
    else
	echo "${WARNING}[TMUXINATOR] Already exists${RESET}"
    fi
}

main() {
    echo "${INFO}Select your desired shell:${RESET}"
    cat /etc/shells
    read CHOICE

    if [ ${CHOICE} = "zsh" ]; then
	setup_zsh
    fi

    if [ ${CHOICE} = "bash" ]; then
	setup_bash
    fi

    echo "${INFO}Do you want to install tmux [y/n]${RESET}"
    read CHOICE

    if [ ${CHOICE} = y ]; then
	setup_tmux
    fi
    
    echo "${INFO}Do you want to install tmuxinator [y/n]${RESET}"
    read CHOICE

    if [ ${CHOICE} = y ]; then
	setup_tmuxinator
    fi
}

main
