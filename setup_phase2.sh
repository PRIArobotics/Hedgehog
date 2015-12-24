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

apt-get -y install sunxi-tools
if [ $? -ne 0 ]; then
    echo "ERROR: Installing sunxi-tools failed! Are you connected to the Internet?"
    exit 1
fi

fex2bin orange_pi2.fex > /media/boot/script.bin

sed -i -re 's/^#+gpio-sunxi$/gpio-sunxi/' /etc/modules

groupadd gpio
usermod -a -G gpio orangepi

cat > /etc/init.d/gpio-permissions <<EOF
#!/bin/sh

### BEGIN INIT INFO
# Provides:          gpio-test.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Set group of GPIO sysfs files
### END INIT INFO

# Using the lsb functions to perform the operations.
. /lib/lsb/init-functions

case $1 in
start)
    find -L /sys/class/gpio_sw -maxdepth 2 -type f -exec chgrp gpio '{}' '+' 2> /dev/null
    log_end_msg 0
    ;;
stop|restart|status|reload)
    log_end_msg 0
    ;;
*)
    # For invalid arguments, print the usage message.
    echo "Usage: $0 {start|stop|restart|reload|status}"
    exit 2
    ;;
esac
EOF

chmod +x /etc/init.d/gpio-permissions
update-rc.d gpio-permissions defaults

echo "SYSTEM WILL NOW REBOOT"
reboot

