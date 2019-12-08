Installation
============

This document describes how to install the software that runs on a Hedgehog controller.
If you have bought a complete controller, it should have come with everything installed and you shouldn't have to do this.
If you somehow can't connect to your controller anymore, you can re-install everything as described here as a last resort.

Hedgehog is made for tinkerers and hackers, so if you enjoy taking apart your devices' hardware and software,
do not shy away from doing so!
If you follow these instructions, you should have no problem restoring the original state of your Hedgehog.

Using a Hedgehog SD card image
------------------------------

By using a prepared image, you can save the time needed to follow the setup described below.
Most often this is the way to go, as you can still install custom software on top of the prepared image,
while saving time because most of the software and more recent system updates are already installed.

Installing a Hedgehog image works the same way as installing plain Raspbian,
`installation instructions`_ can be found at raspberrypi.org.
Of course, instead of using a Raspbian image file, a `Hedgehog image`_ is used.
Hostname (``raspberrypi``), username (``pi``) and password (``raspberry``) are the Raspbian defaults,
but unlike with Rasbian, SSH is enabled!
We might disable SSH by default in future images.

If you are re-installing your controller, that is probably it.
However, if you have a never-used hardware board or there was a firmware update,
or you just want to be on the safe side, go to the :ref:`firmware installation <installation-firmware>` section.

.. _installation instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md
.. _Hedgehog image: http://webspace.pria.at/hedgehog/hedgehog_fresh_20191004_000000.img.zip

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
This means that you need to access your Hedgehog over the network,
and/or provide some configurations before you boot your controller.

Installing Raspbian
^^^^^^^^^^^^^^^^^^^

Like any Raspberry Pi, Hedgehog needs an operating system, for which we use Raspbian.
Downloads_ and `installation instructions`_ can be found at raspberrypi.org.
There is a "lite" version without a graphical user interface, which is sufficient, but you can also install the full version.
Our pre-installed software bundles are built for Raspbian Buster, so make sure you download a recent version.
If you want to use the older Raspbian Stretch, you will have to compile everything from scratch, which will take more time.

Once you are done, don't plug in your SD card and boot your Hedgehog just yet.
Continue with the next section.

.. _Downloads: https://www.raspberrypi.org/downloads/raspbian/

Pre-Boot Setup
^^^^^^^^^^^^^^

Raspbian makes it easy to set up networking without having to configure anything inside Raspbian itself.
This is important if you operate a Raspberry Pi *headless*, i.e. without a keyboard and monitor,
because the network is your only way to access your Raspberry Pi.
Even if you don't work headless it's very easy and therefore our preferred way to set up networking.

Plug your new Raspbian SD card into your computer; you should see a partition named "boot".

WiFi
~~~~

For installation, Hedgehog needs an internet connection.
Also after installation, you will probably want a wireless connection (internet not necessary),
so we suggest that you configure it right now.

To configure a wireless network, put a file named ``wpa_supplicant.conf`` on the boot partition like this::

    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=AT

    network={
        ssid="hedgehog"
        key_mgmt=WPA-PSK
        psk="hedgehog"
    }

You may want to change the country, and of course substitute your own network SSID and pre-shared key ("psk").

.. note::
    You can refer to the `wpa_supplicant.conf manpages`_ for more information on this configuration file.

.. _wpa_supplicant.conf manpages: https://manpage.me/?q=wpa_supplicant.conf

SSH
~~~

In a headless environment, network access is necessary to control a device; with keyboard and monitor, it's optional.
SSH is a simple way to run commands from another machine;
newer versions of Raspbian require you to enable SSH first as a security measure.
To do so, put an empty file named ``ssh``, without any extension, on the boot partition.

Details on this and an overview of client software you can use on your computer can be found
in Raspberry Pi's `SSH documentation`_.

.. _SSH documentation: https://www.raspberrypi.org/documentation/remote-access/ssh/

Host Name (optional)
~~~~~~~~~~~~~~~~~~~~

This requires accessing the "rootfs" partition, which won't work on Windows.
You can also change the host name later, don't worry.

By default, Raspbian configures a hostname of ``raspberrypi``.
If you don't like that, or have multiple Raspberries (including Hedgehogs),
you should change the hostnames to be unique (and to your liking, of course).

To do so, look into the files ``etc/hosts`` and ``etc/hostname`` on the Raspbian root file system,
and change the ocurrences of ``raspberrypi`` to the *same* single word of your liking.
For example, on Linux, this can be achieved like so::

    # change into the Raspbian root partition, then:
    sudo sed -i s/raspberrypi/new-name/ etc/hostname etc/hosts

Booting up & connecting
^^^^^^^^^^^^^^^^^^^^^^^

Now, eject the SD card and put it into your Hedgehog, connect the controller to a battery, and turn it on.

Whatever way you use to log in, the default credentials are ``pi``/``raspberry``.

Connecting and logging in with keyboard & monitor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is straight forward: as soon as the Pi has booted, you should be prompted for username and password.
Make sure the monitor is connected before booting, or the Raspberry Pi may not produce any video.

.. _installation-share-internet:

Connecting via Ethernet directly to your computer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To connect the controller directly to your computer, your computer will need to act as a DHCP server.
Configuring this depends on your operating system.
For Ubuntu Linux, it can be achieved like this:

    *Menu* > *Network Connections* > (select or create an Ethernet connection) > *Edit* > *IPv4 Settings* > *Method: Shared to other computers* > *Save*

In addition to providing addresses via DHCP, this will also let connected devices use your internet connection -
onluess you also configured WiFi earlier, this is necessary during installation.
At other times, you may deactivate your internet connection if you want to prevent that.

Finally, use an Ethernet cable to connect your controller and computer, and make sure that the saved configuration is used.

Connecting to an existing network
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you configured WiFi or connected your Hedgehog to a router via Ethernet,
the Hedgehog should auto-connect to the network and receive a DHCP address.
If you use a network without DHCP (if you don't know what DHCP is, you're probably using it),
we assume that you know how to configure IP addresses manually; we won't cover that here.

Logging in via SSH
~~~~~~~~~~~~~~~~~~

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
If you also have a keyboard and monitor connected to your Raspberry, you can simply execute this command::

    ifconfig

It will show IP addresses for all network interfaces; look out for the ``inet addr:`` label.
If you determined your Hedgehog's IP address to be, for example, ``10.0.0.102``, use this command::

    ssh pi@10.0.0.102

Post-boot setup
^^^^^^^^^^^^^^^

If you want to change your Hedgehog's host name but couldn't before, now is the time.
It works almost the same way as in the pre-boot instructions for Linux.
It's necessary to reboot the controller for the change to take effect::

    sudo sed -i s/raspberrypi/new-name/ /etc/hostname /etc/hosts
    sudo reboot

Running the Hedgehog setup
^^^^^^^^^^^^^^^^^^^^^^^^^^

Now with network connections figured out, we can run the actual Hedgehog setup.
To do this, run the following commands::

    curl -O https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/Makefile
    make setup-rpi checkout-bundle
    cd ~/HedgehogBundle/python && make setup download-archive install-archive
    cd ~/HedgehogBundle/node && make setup install
    . ~/.bashrc
    cd ~/HedgehogBundle/firmware && make setup all
    cd ~/HedgehogBundle/server && make setup install
    cd ~/HedgehogBundle/ide && make setup-release enable-service
    cd ~/HedgehogBundle/boot && make install
    export ENV_NAME=hedgehog-server-0.10.0rc3
    cd ~/HedgehogBundle/opencv && make setup download-archive install-archive

This will **take a while**. We usually run this setup not on a battery powered Hedgehog,
but on a USB powered Raspberry Pi, so that we don't have to worry about power running out.

Let's look at the individual steps:

1.  Download the main Makefile and prepare the setup

    ::

        curl -O https://raw.githubusercontent.com/PRIArobotics/Hedgehog/master/Makefile
        make setup-rpi checkout-bundle

    The first command will download a Makefile, the entry point into the actual Hedgehog setup scripts.
    In the second command, first updates and essential software is installed,
    then the rest of the setup scripts are downloaded.

2.  Install Python

    ::

        cd ~/HedgehogBundle/python && make setup download-archive install-archive

    This line goes to the Python setup scripts and installs all necessary software.
    We install Python 3.7.4 using ``pyenv``.
    ``pyenv`` would install Python from source, which takes a long time.
    To speed things up, we provide a pre-compiled version, but you can also run the full installation yourself::

        cd ~/HedgehogBundle/python && make setup install archive

    The last step is optional and creates a zip file that can be installed using ``install-archive``.

    Normally you'd want to ``. ~/.bashrc`` to have the installed software available,
    but in the setup script that can wait until after the next step:

3.  Install Node

    ::

        cd ~/HedgehogBundle/node && make setup install

    This line goes to the Node setup scripts and installs all necessary software.
    We install Node 7.9.0 using ``nvm``.
    This is rather fast, because ``nvm`` can install a precompiled release.

    .. note::
        We use Node 7.9.0 right now because there were troubles migrating to more up-to-date versions of node.
        In the long term, we're trying to migrate to a more recent Node version.

4.  Make Python and Node available

    ::

        cd ~/HedgehogBundle/firmware && make setup all

    This line applies changes made by ``pyenv`` and ``nvm``.
    Alternatively, you can also log out and back in to the Raspberry Pi.

5.  Install the firmware toolchain and compile the firmware

    ::

        cd ~/HedgehogBundle/firmware && make setup all

    Installing the firmware toolchain will take a while, compiling the firmware itself is quick.

    Note that this does not actually install the firmware!
    As was mentioned above, we usually run this setup on a Raspberry Pi,
    without the Hedgehog hardare controller.
    We also make images after the SD card installation and install those on multiple Hedgehogs.
    In these situations, it does not make sense to install the firmware now,
    because it needs to be repeated later anyway.

    If these considerations do not matter to you, you can of course install the firmware right away::

        cd ~/HedgehogBundle/firmware && make flash

    .. warning::
        The firmware installation is one of the few places where you can "brick" your device:
        The feature that allows Hedgehog to turn itself on and off with the power button needs a working firmware,
        so if you flash a "garbage" firmware, Hedgehog will not power on correctly.
        If you did not edit the firmware though, you will be fine.

    .. todo:: add information on unbricking your Hedgehog

6.  Install the Hedgehog Server

    ::

        cd ~/HedgehogBundle/server && make setup install

    The Hedgehog Server is the component that actually executes Hedgehog commands.
    Installing some of its dependencies is time consuming.

6.  Install the Hedgehog IDE

    ::

        cd ~/HedgehogBundle/ide && make setup-release enable-service

    The Hedgehog IDE is the web application that you use to write your programs.
    As with Python, we provide a pre-compiled version for quicker setup.
    If you want to install it from scratch, use this instead::

        cd ~/HedgehogBundle/ide && make setup-develop enable-service

7.  Install the boot service

    ::

        cd ~/HedgehogBundle/boot && make install

    This service lets the hardware controller know when the Raspberry Pi is turned on and off,
    allowing it to cut the power after shutdown is complete.
    In addition to that, this service reads the WiFi configuration from a flash drive, if you plug one in before boot.

8. Install OpenCV

    ::

        export ENV_NAME=hedgehog-server-0.10.0rc3
        cd ~/HedgehogBundle/opencv && make setup download-archive install-archive

    This installs OpenCV into the Hedgehog Server's Python environment.
    As with Python and the IDE, this uses a pre-compiled version for quicker setup.
    If you want to install it from scratch, use this instead::

        export ENV_NAME=hedgehog-server-0.10.0rc3
        cd ~/HedgehogBundle/opencv && make setup build install archive

    OpenCV is huge and this will take hours!
    You will also need an SD card with at least 32GB of storage.
    The last step, ``archive``, is optional and creates a zip file that can be installed using ``install-archive``.

.. _installation-firmware:

Installing the Hedgehog Firmware
--------------------------------

If you just installed a fresh SD card,
make sure that you reboot your controller to let serial connection settings take effect::

    sudo reboot

Now connect, and install the firmware like this.
The server is stopped before that to make sure the serial connection is free::

    sudo systemctl stop hedgehog-server
    cd ~/HedgehogBundle/firmware && make flash
    sudo systemctl start hedgehog-server

That's it!
Your controller's firmware should be properly reinstalled.

Tips & tricks
-------------

These are some tricks that may or may not be useful in your workflow.

Modifying image files
^^^^^^^^^^^^^^^^^^^^^

On Linux, the ``losetup`` command can be used to use an image file as a loopback device::

    # add the -r option the work read-only
    sudo losetup -P /dev/loop0 path/to/image.img
    # when finished, unmount the partitions, then detach the device:
    sudo losetup -d /dev/loop0

After setting up the loopback device, most linux systems will automatically mount the boot and root partitions.
You can then inspect and even change the image contents, as if it were a real SD card.
