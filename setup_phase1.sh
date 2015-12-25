#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Script must be run as root!"
	exit 1
fi

echo y | fs_resize

cp res/eth0 /etc/network/interfaces.d/

echo "SYSTEM WILL NOW REBOOT"
reboot

