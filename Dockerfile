FROM test:23.04

# Needed for X11 forwarding
ENV DISPLAY :0

# Needed for X11 forwarding
ENV USERNAME developer

WORKDIR /app

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-transport-https \
    software-properties-common \
    sudo xfce4 xfce4-goodies

# create and switch to a user
RUN echo "backus ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN useradd --no-log-init --home-dir /home/$USERNAME --create-home --shell /bin/bash $USERNAME
RUN adduser $USERNAME sudo
RUN passwd $USERNAME --stdin << echo "\ndog\ndog"

# Set environment variable in .bashrc
# When logging in the variable is set
# RUN echo "export DBUS_SESSION_BUS_ADDRESS=$(dbus-daemon --fork --config-file=/usr/share/dbus-1/session.conf --print-address)" >> /home/$USERNAME/.bashrc

# USER $USERNAME

# WORKDIR /home/$USERNAME

# ENTRYPOINT "systemd"

# CMD "flatpak run ${FLATPAK_PKG}"