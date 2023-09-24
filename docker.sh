#!/usr/bin/env bash

export USERNAME="developer"

apt update
apt install -yq xfce4 xfce4-goodies

echo "backus ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
useradd --no-log-init --home-dir /home/$USERNAME --create-home --shell /bin/bash $USERNAME
adduser $USERNAME root

systemd