.PHONY: refresh-makefile setup-rpi setup-opi fix-locale system-upgrade \
		_expand_root_fs _enable_serial _replace_fex _enable_gpio \
		setup-hedgehog setup-hedgehog-develop setup-python \
		setup-server setup-server-develop install-server uninstall-server \
		setup-firmware setup-firmware-develop install-firmware \
		_install_firmware_toolchain _clone_bundle _checkout_bundle_develop _checkout_bundle_master

### system setup

refresh-makefile:
	curl -O https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/Makefile

# public targets - initial setup

setup-rpi: fix-locale _expand_root_fs _enable_serial system-upgrade
	sudo aptitude -y install git usbmount samba

setup-opi: fix-locale _replace_fex _enable_gpio system-upgrade
	@echo "SYSTEM WILL NOW REBOOT"
	sudo reboot

# public targets - maintenance

fix-locale:
	$(call _fix_locale,$(LC_NAME))

system-upgrade:
	sudo apt-get -y update
	sudo apt-get -y install aptitude
	sudo aptitude -y upgrade

# private defines

define _fix_locale
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

# private targets - Raspberry Pi

_expand_root_fs:
	sudo raspi-config nonint do_expand_rootfs
	sudo partprobe

_enable_serial:
	sudo raspi-config nonint do_serial 1
	sudo sed -i -re 's/^ *enable_uart *= *0 *$$/enable_uart=1/' /boot/config.txt

# private targets - Orange Pi

_replace_fex:
	sudo mv /boot/bin/orangepi2.bin /boot/bin/orangepi2.bin.orig
	curl https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/res/orangepi2.fex | \
	    fex2bin | sudo tee /boot/bin/orangepi2.bin > /dev/null

_enable_gpio:
	sudo sed -i -re 's/^#+(gpio[-_]sunxi)$$/\1/' /etc/modules

	sudo groupadd -f gpio
	sudo usermod -a -G gpio `id -nu 1000`

	curl https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/res/gpio-permissions | \
	    sudo tee /etc/init.d/gpio-permissions > /dev/null
	sudo chmod +x /etc/init.d/gpio-permissions
	sudo update-rc.d gpio-permissions defaults

### hedgehog installation

# public targets

setup-hedgehog: setup-server setup-server-raspberry setup-firmware setup-ide

setup-hedgehog-develop: setup-server-develop setup-server-raspberry setup-firmware setup-ide-develop

setup-hedgehog-light: setup-server setup-server-raspberry setup-firmware-light setup-ide

setup-hedgehog-develop-light: setup-server-develop setup-server-raspberry setup-firmware-light setup-ide-develop

setup-python:
	sudo aptitude -y install python3-pip python-dev python3-dev
	sudo pip3 install virtualenv

setup-server: _checkout_bundle_master
	cd HedgehogBundle/server && make setup

setup-server-develop: _checkout_bundle_develop
	cd HedgehogBundle/server && make setup-develop

setup-server-raspberry:
	cd HedgehogBundle/server && make with-raspberry

install-server:
	cd HedgehogBundle/server && make install

uninstall-server:
	cd HedgehogBundle/server && make uninstall

setup-firmware: _install_firmware_toolchain _checkout_bundle_master
	cd HedgehogBundle/firmware && make setup all

setup-firmware-light: _install_firmware_toolchain _checkout_bundle_develop
	cd HedgehogBundle/firmware && make setup-light all

install-firmware:
	cd HedgehogBundle/firmware && make flash

setup-ide: _checkout_bundle_master

setup-ide-develop: _checkout_bundle_develop

install-ide:
	cd HedgehogBundle/ide && make all

# private targets

_install_firmware_toolchain:
	sudo aptitude -y install gcc-arm-none-eabi libnewlib-arm-none-eabi

_clone_bundle:
	test -d HedgehogBundle || git clone https://github.com/PRIArobotics/HedgehogBundle.git

_checkout_bundle_develop: _clone_bundle
	cd HedgehogBundle && git fetch origin develop && git checkout -B develop origin/develop

_checkout_bundle_master: _clone_bundle
	cd HedgehogBundle && git fetch origin master && git checkout -B master origin/master
