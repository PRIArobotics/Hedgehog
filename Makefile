.PHONY: refresh-makefile setup-rpi fix-locale system-upgrade \
		_expand_root_fs _enable_serial \
		setup-hedgehog setup-hedgehog-develop setup-python \
		setup-server setup-server-develop install-server uninstall-server \
		setup-firmware setup-firmware-develop install-firmware \
		_install_firmware_toolchain _clone_bundle _checkout_bundle_develop _checkout_bundle_master

PYTHON_VERSION = 3.7.1
NODE_VERSION = 8.14.0

### system setup

refresh-makefile:
	curl -O https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/Makefile

# public targets - initial setup

setup-rpi: fix-locale _expand_root_fs _enable_serial system-upgrade
	sudo aptitude -y install git usbmount samba
	@echo "SYSTEM WILL NOW REBOOT"
	sudo reboot

# public targets - maintenance

fix-locale:
	$(call _fix_locale,$(LC_NAME))

system-upgrade:
	sudo apt-get -y update
	sudo apt-get -y install aptitude
	sudo aptitude -y upgrade
	sudo rpi-update

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

# private targets

_expand_root_fs:
	sudo raspi-config nonint do_expand_rootfs
	sudo partprobe

_enable_serial:
	sudo raspi-config nonint do_serial 1
	sudo sed -i -re 's/^ *enable_uart *= *0 *$$/enable_uart=1/' /boot/config.txt

### Hedgehog installation

checkout-bundle: _clone_bundle
	cd HedgehogBundle && git fetch origin master && git checkout -B master origin/master

checkout-bundle-develop: _clone_bundle
	cd HedgehogBundle && git fetch origin develop && git checkout -B develop origin/develop

# public targets

setup-hedgehog: setup-server setup-server-raspberry setup-firmware setup-ide

setup-hedgehog-develop: setup-server-develop setup-server-raspberry setup-firmware setup-ide-develop

setup-hedgehog-light: setup-server setup-server-raspberry setup-firmware-light setup-ide

setup-hedgehog-develop-light: setup-server-develop setup-server-raspberry setup-firmware-light setup-ide-develop

setup-python:
	sudo aptitude -y install libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
	    zlib1g-dev xz-utils libxml2-dev libxmlsec1-dev \
	    libncursesw5-dev libgdbm-dev tk-dev liblzma-dev uuid-dev libffi-dev
	curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
	echo '' >> .bashrc
	echo 'export PATH="/home/pi/.pyenv/bin:$$PATH"' >> .bashrc
	echo 'eval "$$(pyenv init -)"' >> .bashrc
	echo 'eval "$$(pyenv virtualenv-init -)"' >> .bashrc
	
	/home/pi/.pyenv/bin/pyenv install $(PYTHON_VERSION)
	/home/pi/.pyenv/bin/pyenv global $(PYTHON_VERSION)

setup-node:
	sudo aptitude -y install libssl-dev libzmq-dev libcurl4-gnutls-dev
	curl -L https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
	
	export NVM_DIR="$$HOME/.nvm" && . "$$NVM_DIR/nvm.sh" && nvm install $(NODE_VERSION)

setup-server: _clone_bundle
	cd HedgehogBundle/server && make setup

setup-server-develop: _clone_bundle
	cd HedgehogBundle/server && make setup-develop

setup-server-raspberry:
	cd HedgehogBundle/server && make with-raspberry

install-server:
	cd HedgehogBundle/server && make install

uninstall-server:
	cd HedgehogBundle/server && make uninstall

setup-firmware: _clone_bundle
	cd HedgehogBundle/firmware && make setup all

setup-firmware-light: _clone_bundle
	cd HedgehogBundle/firmware && make setup-light all

install-firmware:
	cd HedgehogBundle/firmware && make flash

setup-ide: _clone_bundle
	cd HedgehogBundle/ide && make setup-release

setup-ide-develop: _clone_bundle
	cd HedgehogBundle/ide && make setup-develop

install-ide:
	cd HedgehogBundle/ide && make enable-service

uninstall-ide:
	cd HedgehogBundle/ide && make disable-service

# private targets

_clone_bundle:
	test -d HedgehogBundle || git clone https://github.com/PRIArobotics/HedgehogBundle.git
