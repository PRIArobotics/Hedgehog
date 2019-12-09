.. _usage-basics:

Usage Basics
============

Hedgehog is simple to use, but without a display to show you exactly what to do after booting up,
some documentation and explanation is necessary.

Power & turning Hedgehog on and off
---------------------------

Hedgehog has a power cord for connecting your power source - usually a lithium battery.
The micro USB port of the Raspberry Pi (which is not exposed by Hedgehog's case)
should **not** be used in combination with the Hedgehog shield!

To switch Hedgehog on or off, press its red power button until you hear a sound.
The power LED will show a rising pulse while Hedgehog is booting,
and a falling pulse while shutting down.
After successful boot, the power LED will remain turned on.

.. note::
    If the power LED does not stop pulsing after turning Hedgehog on,
    either the boot service on the Raspberry Pi is not working correctly,
    or an old firmware is installed.
    Neither should happen if following the installation instructions.

Hedgehog will start beeping when its battery runs low on power.
To avoid damaging the battery, which might increase the risk of fire,
shut down Hedgehog as quickly as possible in that case!

Setting up a network connection
-------------------------------

Although a screen and keyboard may be connected to Hedgehog directly,
the default operating system does not provide a graphical user interface and thus does not allow using the Hedgehog IDE.
Also, especially while built into a robot, accessing Hedgehog wirelessly is more convenient anyway.

Using the default WiFi configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Unless you re-installed the controller's operating system, Hedgehog comes with a WiFi pre-configured::

    SSID: hedgehog
    Key: hedgehog
    Encryption: WPA-PSK

You can use your phone to open a WiFi hotspot with that configuration,
and Hedgehog will then automatically connect with it.
Using a WiFi router or similar works in the same way, of course.

Using a wired network
^^^^^^^^^^^^^^^^^^^^^

If you prefer a wired connection, you can use the Hedgehog's Ethernet port,
but (as with WiFi) you will have to ensure that the network provides a DHCP address to the controller.
Connecting to a router would normally work.

If you want to connect directly to your computer,
you will have to configure something like connection forwarding in a platform-dependent way.
In the installation document, :ref:`installation-share-internet` describes this for selected platforms.

Changing the network configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you can't (or don't want to) use the default ``hedgehog`` network,
there is a simple mechanism to provide alternative network configurations on a flash drive.
The new configuration is stored on the controller, so this is only necessary when network settings change.
The caveats for flashdrives on the Raspberry Pi/Raspbian apply:
excessively large drives (> ~64GiB) and unsupported file systems (such as NTFS) may not work.

To change the network configuration, put a file named ``wpa_supplicant.conf`` on your flash drive like this::

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

Once this file is on your flash drive, plug it into your turned off Hedgehog, and turn it on.
Once the power LED has stopped pulsing, the configuration file has been copied onto your Hedgehog.
Reboot once more, and Hedgehog should connect to the newly configured WiFi network.

Using the Hedgehog IDE
----------------------

The Hedgehog IDE is the most common interface for working with Hedgehog.
Once a network connection is established,
it can be accessed via a web browser by navigating to the Hedgehog's host name.

``raspberrypi`` is the default hostname for a Raspbian installation, including Hedgehog.
Our Hedgehogs ship with a hostname based on its serial number,
which can be seen through the transparent Hedgehog case.
For example, Hedgehog controller ``9`` would have hostname ``hedgehog9``.

The IDE was most thoroughly tested on Chrome/Chromium, so we recommend this browser whenever possible.
Other browsers should work as well, though.
In the browser, open the address ``http://raspberrypi.local/``, replacing ``raspberrypi`` by the Hedgehog's host name.
Write out the full address, as some browsers may think ``raspberrypi.local`` is a search term, not an address.

The browser should show a circular loading sign and quickly load the IDE's main screen.

.. todo::
    more IDE usage
