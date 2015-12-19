#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Script must be run as root!"
	exit 0
fi

apt-get update
apt-get -y upgrade
apt-get -y install sunxi-tools

fex2bin orange_pi2.fex > /media/boot/script.bin

sed -i -re 's/^#+gpio-sunxi$/gpio-sunxi/' /etc/modules

echo "SYSTEM WILL NOW REBOOT"
reboot

