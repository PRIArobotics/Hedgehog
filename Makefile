.PHONY: setup fixlocale python-setup server-setup firmware-setup

setup-raspberrypi-phase1:
	test "`id -u`" = "0" || (\
	    echo "ERROR: Script must be run as root!" &&\
	    exit 1)

	raspi-config nonint do_expand_rootfs
	raspi-config nonint do_serial 1

	@echo "SYSTEM WILL NOW REBOOT"
	reboot

setup-raspberrypi-phase2:
	test "`id -u`" = "0" || (\
	    echo "ERROR: Script must be run as root!" &&\
	    exit 1)

	@echo "Install system updates..."
	apt-get update || (\
	    echo "ERROR: apt-get update failed! Are you root & connected to the Internet?" &&\
	    exit 1)
	apt-get -y upgrade || (\
	    echo "ERROR: apt-get update failed! Are you root & connected to the Internet?" &&\
	    exit 1)


setup-orangepi:
	test "`id -u`" = "0" || (\
	    echo "ERROR: Script must be run as root!" &&\
	    exit 1)

	@echo "Install system updates..."
	apt-get update || (\
	    echo "ERROR: apt-get update failed! Are you root & connected to the Internet?" &&\
	    exit 1)
	apt-get -y upgrade || (\
	    echo "ERROR: apt-get update failed! Are you root & connected to the Internet?" &&\
	    exit 1)

	@echo "Enable UARTs..."
	mv /boot/bin/orangepi2.bin /boot/bin/orangepi2.bin.orig
	fex2bin res/orangepi2.fex > /boot/bin/orangepi2.bin

	@echo "Enable GPIOs..."
	sed -i -re 's/^#+(gpio[-_]sunxi)$$/\1/' /etc/modules

	groupadd gpio
	usermod -a -G gpio `id -nu 1000`

	cp res/gpio-permissions /etc/init.d/
	chmod +x /etc/init.d/gpio-permissions
	update-rc.d gpio-permissions defaults

	@echo "Install NetworkManager"
	cp /etc/network/interfaces /etc/network/interfaces.orig
	sed -i -re 's/^[^#].*(eth|wlan)[0-9]+.*$$/#\0/' /etc/network/interfaces

	apt-get -y install network-manager || (\
	    rm /etc/network/interfaces &&\
	    mv /etc/network/interfaces.orig /etc/network/interfaces &&\
	    echo "ERROR: Installing additional software failed! Are you connected to the Internet?" &&\
	    exit 1)

	@echo "IF YOU ARE CONNECTED VIA SSH, YOU WILL BE DISCONNECTED NOW!"
	@echo "WAIT FOR THE ORANGE PI TO REBOOT, THEN REONNECT"
	nmcli connection delete eth0
	nmcli connection add type ethernet ifname eth0 autoconnect yes

	@echo "SYSTEM WILL NOW REBOOT"
	reboot

fixlocale:
	test "`id -u`" = "0" || (\
	    echo "ERROR: Script must be run as root!" &&\
	    exit 1)

	./fixlocale.sh

python-setup:
	test "`id -u`" = "0" || (\
	    echo "ERROR: Script must be run as root!" &&\
	    exit 1)

	apt-get -y install python3-pip python-dev python3-dev
	pip3 install virtualenv

server-setup:
	git clone https://github.com/PRIArobotics/HedgehogServerBundle.git ../HedgehogServerBundle
	cd ../HedgehogServerBundle && \
	    git submodule init && \
	    git submodule update && \
	    make env && \
	    make protoc

firmware-setup:
	sudo apt-get -y install gcc-arm-none-eabi libnewlib-arm-none-eabi
	git clone https://github.com/PRIArobotics/HedgehogFirmwareBundle.git ../HedgehogFirmwareBundle
	cd ../HedgehogFirmwareBundle && \
	    git submodule init && \
	    git submodule update && \
	    make env
