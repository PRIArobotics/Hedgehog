.PHONY: refresh-makefile setup-rpi fix-locale system-upgrade \
		_expand_root_fs _enable_serial \
		setup-hedgehog setup-hedgehog-develop setup-python \
		setup-server setup-server-develop install-server uninstall-server \
		setup-firmware setup-firmware-develop install-firmware \
		_install_firmware_toolchain _clone_bundle _checkout_bundle_develop _checkout_bundle_master

PYTHON_VERSION = 3.7.4
NODE_VERSION = 7.9.0

### system setup

refresh-makefile:
	curl -O https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/Makefile

# public targets - initial setup

setup-rpi: fix-locale _expand_root_fs _enable_serial system-upgrade
	sudo apt -y install git samba

# public targets - maintenance

fix-locale:
	$(call _fix_locale,$(LC_NAME))

system-upgrade: rpi-update
	sudo apt -y update
	sudo apt -y upgrade

rpi-update:
	# rpi-update warns against using it in a blanket fashion, so don't do it here
	# sudo rpi-update
	# a reboot is required to apply RPi firmware updates

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
	cd HedgehogBundle && git fetch origin +refs/heads/master:refs/remotes/origin/master && git checkout -B master origin/master

checkout-bundle-develop: _clone_bundle
	cd HedgehogBundle && git fetch origin +refs/heads/develop:refs/remotes/origin/develop && git checkout -B develop origin/develop

# private targets

_clone_bundle:
	test -d HedgehogBundle || git clone --depth 1 https://github.com/PRIArobotics/HedgehogBundle.git
