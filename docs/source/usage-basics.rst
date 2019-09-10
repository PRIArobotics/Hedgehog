.. _usage-basics:

Usage Basics
============

Hedgehog is simple to use, but without a display to show you exactly what to do after booting up,
some documentation and explanation is necessary.

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
If you want to connect directly to your computer,
you will have to configure something like connection forwarding in a platform-dependent way.
In the installation document, :ref:`installation-share-internet` describes this for selected platforms.

Changing the network configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you can't (or don't want to) use the default ``hedgehog`` network,
there is a simple mechanism to provide alternative network configurations over a config file on a flash drive.
The new configuration is stored on the controller, so this is only necessary when network settings change.

The caveats for flashdrives on the Raspberry Pi/Raspbian apply:
excessively large drives (> ~64GiB) and unsupported file systems (such as NTFS) may not work.
An example config file looks like this::

    [default]
    # the server port. this can be overwritten by passing `-p`, `--port`
    # it is STRONGLY advised to not change the port,
    # because programs connect to this port by default
    port = 10789

    [wifi]
    # these commands are not stored as configuration on the controller,
    # they are executed once by passing them to wpa_cli
    commands =
        # "flush" clears any previous configuration; it is generally necessary to have predictable network numbers
        flush
        add_network
        set_network 0 ssid "hedgehog"
        set_network 0 key_mgmt WPA-PSK
        set_network 0 psk "hedgehog"
        enable_network 0
        # "save_config" stores the settings to wpa_supplicant.conf, so that the settings persist after a reboot
        save_config

.. todo::
    Skipping the ``default`` section will currently delete that part of the configuration.
    Make it non-mandatory!

The relevant part here is the ``[wifi]`` section, containing a ``commands`` option.
This option contains any number of indented lines used to configure WiFi using the Linux ``wpa_cli`` command.
For details on using ``wpa_cli``, refer to :ref:`the installation document <installation-connect-network>`,
particularly the comments on non-interactive usage.
You can also refer to the Linux man pages for more detailed information::

    man wpa_cli
    man wpa_supplicant.conf

Using the Hedgehog IDE
----------------------

The Hedgehog IDE is the most common interface for working with Hedgehog.
Once a network connection is established, it can be accessed via a web browser.
The IDE was most thoroughly tested on Chrome/Chromium, so we recommend this browser whenever possible.
Other browsers should work as well, though.

In the browser, open the address ``http://raspberrypi.local/``, where ``raspberrypi`` is the Hedgehog's host name.
Write out the full address, as some browsers may think ``raspberrypi.local`` is a search term, not an address.

If you changed the host name of your device, replace that part with whatever you configured.
If you got a Hedgehog controller with a number on it,
the host name is normally set to ``hedgehog#``, with ``#`` being that number.

The browser should show a circular loading sign and quickly load the IDE's main screen.

.. todo::
    more IDE usage
