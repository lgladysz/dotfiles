#!/usr/bin/env bash

source ./lib_sh/shell_helpers.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

# Ask for the administrator password upfront
if ! sudo grep -q "%wheel		ALL=(ALL) NOPASSWD: ALL #dotfiles" "/etc/sudoers.d/wheel" > /dev/null 2>&1; then

    # Ask for the administrator password upfront
    bot "I need you to enter your sudo password so I can install some things:"
    sudo -v

    # Keep-alive: update existing sudo time stamp until the script has finished
    while true; do
        sudo -n true;
        sleep 60;
        kill -0 "$$" || exit;
    done 2> /dev/null &

    bot "Do you want me to setup this machine to allow you to run sudo without a password?"

    read -r -p "Make sudo passwordless? [y|N] " response
    if [[ ${response} =~ (yes|y|Y) ]]; then
        sudo cp ./configs/sudo/wheel /etc/sudoers.d/wheel
        sudo chmod 0440 /etc/sudoers.d/wheel
        sudo chown root:root /etc/sudoers.d/wheel
        if ! groups | grep wheel > /dev/null 2>&1; then
            if ! grep "wheel" "/etc/group" > /dev/null 2>&1; then
                sudo groupadd wheel
            fi
            sudo usermod -a -G wheel $USER
        fi
        bot "You can now run sudo commands without password!"
    fi
fi

bot "Woot! All done. Kill this terminal and reboot machine"