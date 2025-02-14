#!/bin/sh

utf8_locale=$(locale -a 2>/dev/null | grep -i -m 1 -E "UTF-8|utf8")
if [[ -z "$utf8_locale" ]]; then
  echo "No UTF-8 locale found"
else
  export LC_ALL="$utf8_locale"
  export LANG="$utf8_locale"
  export LANGUAGE="$utf8_locale"
  echo "Locale set to $utf8_locale"
fi
red() { printf  "\033[31m\033[01m$1$2\033[0m"; }
green() { printf  "\033[32m\033[01m$1$2\033[0m"; }
yellow() { printf  "\033[33m\033[01m$1$2\033[0m"; }
reading() { read -rp "$1" "$2"; }

prompt_user() {
    local message="$1"
    read -rp "$(green "${message}") $(red "[y/n]:")" confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        return 0
    else
        return 1
    fi
}

is_exist(){
    if command -v $1 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

clear

if prompt_user "编译依赖安装"; then
    sudo apt update 
    sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
fi

if  ! is_exist fish && prompt_user "fish"; then
    sudo apt-add-repository ppa:fish-shell/release-3  
    sudo apt update  
    sudo apt install fish
    chsh -s /usr/bin/fish
    curl -sS https://starship.rs/install.sh | sh
    echo starship init fish | source >> ~/.config/fish/config.fish
fi

if  ! is_exist uv && prompt_user "uv"; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv python install 3.12
fi

if  ! is_exist cmake && prompt_user "cmake & ruff"; then
    uv tool install cmake
    uv tool install ruff
fi

if ! is_exist clang && prompt_user "clang"; then
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    sudo ./llvm.sh 18 all
fi


if  ! is_exist rustc && prompt_user "rust"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if  ! is_exist zellij && prompt_user "zellij"; then
    cargo install --locked zellij
fi

if  ! is_exist hx && prompt_user "Helix"; then
    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install helix
fi


