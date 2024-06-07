if [ "$(id -u)" -ne 0 ]; then
    echo "need root:"
    exec sudo zsh "$0" "$@"
fi

prompt_user() {
    local message=$1
    echo -e "\033[32m$message\033[0m \033[31m(y/p):\033[0m"
    read answer
    if [[ $answer == "y" || $answer == "Y" ]]; then
        return 0
    else
        return 1
    fi
}

is_exist(){
    if command -v $1 > /dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

if prompt_user "编译依赖安装"; then
    apt update 
    apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
fi

if prompt_user "oh my zsh"; then
    apt install zsh -y
    sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
    
fi

if  ! is_exist puenv && prompt_user "pyenv & uv"; then
    curl https://pyenv.run | zsh
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    source ~/.zshrc
    pyenv install 3.12
    pyenv global 3.12
    pip install uv
fi

if ! is_exist cmake && prompt_user "Cmake & Ninja"; then
    pip install cmake
    apt install ninja-build
fi

if ! is_exist rustc && prompt_user "rust"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! is_exist zellij && prompt_user "zellij"; then
    cargo install --locked zellij
fi

if  ! is_exist Starship && prompt_user "Starship"; then
    curl -sS https://starship.rs/install.sh | sh
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

if ! is_exist hx && prompt_user "Helix"; then
    add-apt-repository ppa:maveonair/helix-editor
    apt update
    apt install helix
fi



