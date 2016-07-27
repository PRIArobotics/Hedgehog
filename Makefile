.PHONY: system-setup fix_locale expand_root_fs enable_serial system_upgrade \
		setup-orangepi python-setup server-setup firmware-setup

system-setup: fix_locale expand_root_fs enable_serial system_upgrade
	sudo aptitude -y install git


define fix_locale
    @if [ "x" != "x$(1)" ]; then \
        sum="`md5sum /etc/locale.gen`"; \
        sudo sed -i -re 's/^# *($(1).*)$$/\1/' /etc/locale.gen; \
        if [ "$$sum" = "`md5sum /etc/locale.gen`" ]; then \
            echo "no changes were made! $(1) is not a valid locale or already enabled"; \
        else \
            sudo locale-gen; \
        fi \
    fi
endef

fix_locale:
	$(call fix_locale,$(LC_NAME))

expand_root_fs:
	sudo raspi-config nonint do_expand_rootfs
	sudo partprobe

enable_serial:
	sudo raspi-config nonint do_serial 1
	sudo sed -i -re 's/^ *enable_uart *= *0 *$$/enable_uart=1/' /boot/config.txt

system_upgrade:
	sudo aptitude -y update
	sudo aptitude -y upgrade


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


python-setup:
	sudo aptitude -y install python3-pip python-dev python3-dev
	sudo pip3 install virtualenv

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
