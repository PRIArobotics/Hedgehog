#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Script must be run as root!"
	exit 1
fi

apt-get update
if [ $? -ne 0 ]; then
    echo "ERROR: apt-get update failed! Are you connected to the Internet?"
    exit 1
fi

apt-get -y upgrade
if [ $? -ne 0 ]; then
    echo "ERROR: apt-get upgrade failed! Are you connected to the Internet?"
    exit 1
fi

mv /boot/bin/orangepi2.bin /boot/bin/orangepi2.bin.orig
fex2bin res/orangepi2.fex > /boot/bin/orangepi2.bin

sed -i -re 's/^#+gpio-sunxi$/gpio-sunxi/' /etc/modules

groupadd gpio
usermod -a -G gpio `id -nu 1000`

cp res/gpio-permissions /etc/init.d/
chmod +x /etc/init.d/gpio-permissions
update-rc.d gpio-permissions defaults

cp /etc/network/interfaces /etc/network/interfaces.orig
sed -i -re 's/^[^#].*(eth|wlan)[0-9]+.*$/#\0/' /etc/network/interfaces

apt-get -y install network-manager
if [ $? -ne 0 ]; then
    rm /etc/network/interfaces
    mv /etc/network/interfaces.orig /etc/network/interfaces
    echo "ERROR: Installing additional software failed! Are you connected to the Internet?"
    exit 1
fi

nmcli connection delete eth0
nmcli connection add type ethernet ifname eth0 autoconnect yes

echo "SYSTEM WILL NOW REBOOT"
reboot

