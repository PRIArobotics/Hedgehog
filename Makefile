.PHONY: system-setup fix_locale expand_root_fs enable_serial system_upgrade \
		python-setup server-setup firmware-setup

rpi-setup: fix_locale expand_root_fs enable_serial system_upgrade
	sudo aptitude -y install git usbmount

opi-setup: fix_locale replace_fex enable_gpio system_upgrade
	@echo "SYSTEM WILL NOW REBOOT"
	sudo reboot


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
	sudo apt-get -y update
	sudo apt-get -y install aptitude
	sudo aptitude -y upgrade

replace_fex:
	sudo mv /boot/bin/orangepi2.bin /boot/bin/orangepi2.bin.orig
	curl https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/res/orangepi2.fex | \
	    fex2bin | sudo tee /boot/bin/orangepi2.bin > /dev/null

enable_gpio:
	sudo sed -i -re 's/^#+(gpio[-_]sunxi)$$/\1/' /etc/modules

	sudo groupadd -f gpio
	sudo usermod -a -G gpio `id -nu 1000`

	curl https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/res/gpio-permissions | \
	    sudo tee /etc/init.d/gpio-permissions > /dev/null
	sudo chmod +x /etc/init.d/gpio-permissions
	sudo update-rc.d gpio-permissions defaults

get_bundle:
	test -d HedgehogBundle || git clone https://github.com/PRIArobotics/HedgehogBundle.git


python-setup:
	sudo aptitude -y install python3-pip python-dev python3-dev
	sudo pip3 install virtualenv

server-setup: get_bundle
	cd HedgehogBundle/server && make setup install

server-develop-setup: get_bundle
	cd HedgehogBundle/server && make setup-develop install

firmware-setup: get_bundle
	sudo apt-get -y install gcc-arm-none-eabi libnewlib-arm-none-eabi
	cd HedgehogBundle/firmware && make setup all flash

firmware-develop-setup: get_bundle
	sudo apt-get -y install gcc-arm-none-eabi libnewlib-arm-none-eabi
	cd HedgehogBundle/firmware && make setup-develop all flash
