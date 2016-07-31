.PHONY: system-setup fix_locale expand_root_fs enable_serial system_upgrade \
		python-setup server-setup firmware-setup

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


python-setup:
	sudo aptitude -y install python3-pip python-dev python3-dev
	sudo pip3 install virtualenv

server-setup:
	git clone https://github.com/PRIArobotics/HedgehogServerBundle.git
	cd HedgehogServerBundle && \
	    git submodule init && \
	    git submodule update && \
	    make env && \
	    make protoc

firmware-setup:
	sudo apt-get -y install gcc-arm-none-eabi libnewlib-arm-none-eabi
	git clone https://github.com/PRIArobotics/HedgehogFirmwareBundle.git
	cd HedgehogFirmwareBundle && \
	    git submodule init && \
	    git submodule update && \
	    make env
