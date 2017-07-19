Installation
============

This document describes how to install the software that runs on a Hedgehog controller.
If you have bought a complete controller, it should have come with everything installed and you shouldn't have to do this.
If you somehow can't connect to your controller anymore, you can re-install everything as described here as a last resort.

Using a Hedgehog SD card image
------------------------------

By using a prepared image, you can save the time needed to follow the setup described below.
Most often this is the way to go, as you can still install custom software on top of the prepared image,
while saving time because most of the software and more recent system updates are already installed.

Installing a Hedgehog image works the same way as installing plain Raspbian,
`installation instructions`_ can be found at raspberrypi.org.
Of course, instead of using a Raspbian image file, a `Hedgehog image`_ is used.
Hostname (`raspberrypi`), username (`pi`) and password (`raspberry`) are the Raspbian defaults,
but unlike with Rasbian, SSH is enabled!
We might disable SSH by default in future images.

.. _installation instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md
.. _Hedgehog image: http://webspace.pria.at/hedgehog/hedgehog_fresh_20170708_030000.img.zip

Installing from scratch
-----------------------

Installing a Hedgehog is a simple step-by-step procedure:

- installing the operating system
- ensuring you can run commands on the hedgehog:
    - by connecting keyboard and monitor; or
    - by enabling SSH
- connecting Hedgehog to the internet
    - via Ethernet
    - via WiFi
- executing the setup scripts

If you don't want to use keyboard and monitor, Hedgehog is a *headless* device.
This means that you need to access your Hedgehog over the network, and/or provide some configurations before you boot your controller.
We provide instructions for both options, but configuring WiFi requires you to access the ext4 root file system, for which you may need a Linux machine.
If you run another operating system and can't access the root partition, please use a wired connection or keyboard and mouse initially.

If you're using keyboard and monitor, you can still follow the headless instructions instead of equivalent headed instructions if you feel like it.

Installing Raspbian
^^^^^^^^^^^^^^^^^^^

Like any Raspberry Pi, Hedgehog needs an operating system, for which we use Raspbian.
Downloads_ and `installation instructions`_ can be found at raspberrypi.org.
There is a "lite" version without a graphical user interface, which is sufficient, but you can also install the full version.

Once you are done, don't plug in your SD card and boot your Hedgehog just yet, especially if you want to work headless.
Continue with the next section.

.. _Downloads: https://www.raspberrypi.org/downloads/raspbian/

Pre-Boot Setup in Headless Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Without monitor and keyboard, some configurations need to be done before you boot your controller for the first time.
Even if you use computer peripherals, you have the choice to follow these instructions instead of the equivalent instructions later on.

SSH
~~~

In a headless environment, network access is necessary to control a device; with peripherals, it's optional.
SSH is a simple way to run commands from another machine; newer versions of Raspbian require you to `enable SSH`_ first as a security measure.
Follow the instructions for headless Raspberry Pis:

    For headless setup, SSH can be enabled by placing a file named ssh, without any extension, onto the boot partition of the SD card.
    When the Pi boots, it looks for the  ssh file.
    If it is found, SSH is enabled, and the file is deleted.
    The content of the file does not matter: it could contain text, or nothing at all.

The instructions also contain an overview of client software you can use on your computer.

WiFi
~~~~

For this, you will need to access the ext4 root file system, for which you may need a Linux machine.
If you can't access the root partition, please use a wired connection, or keyboard and a monitor.

.. todo:: add instructions

Host Name (optional)
~~~~~~~~~~~~~~~~~~~~

Again, this requires accessing the root partition.

By default, Raspbian configures a network name of ``raspberrypi``.
If you don't like that, or have multiple Raspberries (including Hedgehogs),
you should change the hostnames to be unique (and to your liking, of course).

To do so, look into the files ``etc/hosts`` and ``etc/hostname`` on the Raspbian root file system,
and change the ocurrences of ``raspberrypi`` to the *same* single word of your liking.
For example, on Linux, this can be achieved like so::

    # change into the Raspbian root partition, then:
    sudo sed -i s/raspberrypi/new-name/ etc/hostname etc/hosts

Booting up & connecting
^^^^^^^^^^^^^^^^^^^^^^^

Now, put the SD card into your Hedgehog, connect the controller to a battery, and turn it on.

Whatever way you use to log in, the default credentials are ``pi``/``raspberry``.

Connecting with keyboard & monitor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is straight forward: as soon as the Pi has booted, you should be prompted for username and password.

.. _installation-share-internet:

Connecting via Ethernet directly to your computer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To connect the controller directly to your computer, your computer will need to act as a DHCP server.
Configuring this depends on your operating system.
For Ubuntu Linux, it can be achieved like this:

    *Menu* > *Network Connections* > (select or create an Ethernet connection) > *Edit* > *IPv4 Settings* > *Method: Shared to other computers* > *Save*

In addition to providing addresses via DHCP, this will also let connected devices use your internet connection -
during installation, this is necessary.
At other times, you may deactivate your internet connection if you want to prevent that.

Finally, use an Ethernet cable to connect your controller and computer, and make sure that the saved configuration is used.

Connecting to an existing network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you configured WiFi or connected your Hedgehog to a router via Ethernet,
the Hedgehog should auto-connect to the network and receive a DHCP address.
If you use a network without DHCP (if you don't know what DHCP is, you're probably using it),
we assume that you know how to configure IP addresses manually; we won't cover that here.

Now, to connect to the controller, you need either its host name or its IP address.
Best, first try this (substitute your hostname)::

    ssh pi@raspberrypi.local

.. note::
    ``pi`` is the user name and ``raspberrypi.local`` is the host to connect to;
    this is how you use the default Linux SSH client.
    If you use a different SSH client program, refer to its documentation.


Host name resolution is platform dependent and might not work on some platforms out of the box, especially Windows.
(the actual software setup will install a package that adds Windows support,
but that doesn't help for the very first connection).
If it doesn't work, you need to find out the controller's IP address.
If also have a keyboard and monitor, you can simply execute this command::

    ifconfig

It will show IP addresses for all network interfaces; look out for the ``inet addr:`` label.
If you determined your Hedgehog's IP address to be, for example, ``10.0.0.102``, use this command::

    ssh pi@10.0.0.102

Post-boot setup
^^^^^^^^^^^^^^^

Depending on your way of connection and what you configured pre-boot, you can skip some of the following steps.

SSH (optional)
~~~~~~~~~~~~~~

If you plan on using SSH, either now or later on, read on.
Otherwise, you can skip this.

Newer versions of Raspbian require you to `enable SSH`_ before using it; this is a security measure, as SSH allows remote access to a computer.
The instructions also contain an overview of client software you can use on your computer.

.. _enable SSH: https://www.raspberrypi.org/documentation/remote-access/ssh/

.. _installation-connect-network:

Connecting to a network & the Internet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

During installation only, an Internet connection is required.
Whenever you use SSH, you will also need a network connection, even if that network does not have Internet access.

If you're not using SSH right now and thus already have a network connection, do one of the following.
Needless to say, whatever network you connect to, it needs to be connected to the Internet:

- :ref:`Share your computer's internet connection over Ethernet <installation-share-internet>`,
- Connect to a DHCP-enabled wired network, or
- Configure a wireless connection as explained right below.

.. note::
    These instructions are also useful after the initial installation, to add new network connections.

In a headed environment (or if you already have an SSH connection via another network),
the ``wpa_cli`` command can be used to configure wireless networks interactively, like this::

    sudo wpa_cli
    > add_network
    0
    > set_network 0 ssid "network-1"
    OK
    > set_network 0 key_mgmt WPA-PSK
    OK
    > set_network 0 psk "secret"
    OK
    > enable_network 0
    OK
    ...
    > save_config
    OK

This was for a WPA Personal secured WiFi.
Configuring a WPA Enterprise secured WiFi might look like this::

    sudo wpa_cli
    > add_network
    1
    > set_network 1 ssid "network-2"
    OK
    > set_network 1 key_mgmt WPA-EAP
    OK
    > set_network 1 eap PEAP
    OK
    > set_network 1 identity "username"
    OK
    > set_network 1 password "password"
    OK
    > enable_network 1
    OK
    ...
    > save_config
    OK

``wpa_cli`` can also be used non-interactively.
For example, our Hedgehogs come with the following WiFi pre-configured::

    sudo wpa_cli <<EOF
        flush
        add_network
        set_network 0 ssid "hedgehog"
        set_network 0 key_mgmt WPA-PSK
        set_network 0 psk "hedgehog"
        enable_network 0
        save_config
    EOF

Note the initial ``flush`` command: this deletes all previous network connections.
This is generally necessary for non-interactive network configuration
because you want to be sure the network numbers are known, i.e. start at zero.

More options and usage information can be found in the man pages::

    man wpa_cli
    man wpa_supplicant.conf

Host Name (optional)
~~~~~~~~~~~~~~~~~~~~

Changing the host name works the same way as in the pre-boot instructions for Linux.
It's necessary to reboot the controller for the change to take effect::

    sudo sed -i s/raspberrypi/new-name/ /etc/hostname /etc/hosts
    sudo reboot

Running the Hedgehog setup
^^^^^^^^^^^^^^^^^^^^^^^^^^

Now with network connections figured out, we can run the actual Hedgehog setup.
To do this, run the following commands::

    curl -O https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/Makefile
    make setup-rpi setup-python setup-hedgehog install-server install-ide

The first command will download a Makefile, the actual Hedgehog setup script.
The second command runs it, performing a couple of stacks;
this will download a lot of software (so make sure you don't run into a data limit, and have enough battery and time)
and install it:

- configure the current locale

  If you connect via SSH, the shell will use the connecting system's locale,
  which may not be installed and in turn lead to errors.
  Installing the necessary locale will prevent errors now and for subsequent connections.

- extend partition

  Before installing software, the root partition is expanded to the full SD card size to accomodate it.

- activate serial connections

  Hedgehog uses the Raspberry's serial port to talk to the hardware controller, so this needs to be enabled.
  This only goes into effect after a reboot.

- update system software

  The freshly-installed image may not contain latest software updates, so install them

- install additional system software

  - ``git`` is installed to handle Hedgehog software
  - ``usbmount`` allows to automatically mount USB flash drives, e.g. to auto-load configuration files
  - ``samba`` enables hostname resolution with Windows

- install Python

  Considerable parts of Hedgehog are written in Python, so the necessary software is installed

- install Hedgehog packages:

  - The :ref:`Hedgehog Server <repo-HedgehogServer>`
  - The :ref:`Hedgehog Firmware <repo-HedgehogLightFirmware>`
  - The :ref:`Hedgehog IDE <repo-hedgehog-ide>`

  The Server and IDE are installed to start automatically.
  Installing the firmware requires a serial connection, and that requires a reboot.

You are now done installing the Raspberry Pi software!
If you are re-installing your controller, that is probably it.
However, if you have a never-used hardware board or there was a firmware update,
or you just want to be on the safe side, the next section shows how to install the firmware.

Installing the Hedgehog Firmware
--------------------------------

If you just installed a fresh SD card,
make sure that you reboot your controller to let serial connection settings take effect::

    sudo reboot

Now connect, and install the firmware like this.
The server is stopped before that to make sure the serial connection is free::

    sudo service hedgehog-server stop
    make install-firmware
    sudo service hedgehog-server start

That's it!
Your controller's firmware should be properly reinstalled.
