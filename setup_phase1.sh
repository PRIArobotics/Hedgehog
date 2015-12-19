#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Script must be run as root!"
	exit 0
fi

echo y | fs_resize

cat > /etc/network/interfaces.d/eth0 <<EOF
auto eth0
iface eth0 inet dhcp
EOF

echo "SYSTEM WILL NOW REBOOT"
reboot

