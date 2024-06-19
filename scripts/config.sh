#!/bin/bash

options=("All" "Helix" "Clang" "Quit")


Helix(){
    wget https://nhysteric.github.io/config/helix/config.toml -O helix.toml
    mv helix.toml ~/.config/helix/config.html
}

Clang(){
    wget https://nhysteric.github.io/config/clang/cpp.clang-format
    mkdir -p ~/.config/clang
    mv cpp.clang-format ~/.config/clang/cpp.clang-format
}

select opt in "${options[@]}"
do
    case $opt in
        "All")
            echo "You chose option 1"
            break
            ;;
        "Helix")
            Helix
            ;;
        "Clang")
            Clang
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done