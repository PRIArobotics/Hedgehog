#!/bin/bash

# add language used by connecting system
LC="$LC_NAME"
if [ "x" != "x$LC" ]; then
    sum="`md5sum /etc/locale.gen`"
    sudo sed -i -re 's/^# *('"$LC"'.*)$/\1/' /etc/locale.gen
    if [ "$sum" = "`md5sum /etc/locale.gen`" ]; then
        echo "no changes were made! $LC is not a valid locale or already enabled"
    else
        sudo locale-gen
    fi
fi

# expand file system and reload partition table
sudo raspi-config nonint do_expand_rootfs
sudo partprobe

# enable serial
sudo raspi-config nonint do_serial 1
sudo sed -i -re 's/^ *enable_uart *= *0 *$/enable_uart=1/' /boot/config.txt

# install OS updates & git
sudo aptitude update
sudo aptitude upgrade
sudo aptitude install git

# clone Hedgehog Setup repository
git clone https://github.com/PRIArobotics/HedgehogLightSetup.git

# reboot
echo "SYSTEM WILL NOW REBOOT"
sudo reboot
