Installation
============

This document describes how to install the software that runs on a Hedgehog controller.
If you have bought a complete controller, it should have come with everything installed and you shouldn't have to do this.
If you somehow can't connect to your controller anymore, you can re-install everything as described here as a last resort.

Using a Hedgehog SD card image
------------------------------

.. todo:: link to complete Hedgehog SD card images

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

Installing Raspbian
^^^^^^^^^^^^^^^^^^^

Like any Raspberry Pi, Hedgehog needs an operating system, for which we use Raspbian.
Downloads_ and `installation instructions`_ can be found at raspberrypi.org.
There is a "lite" version without a graphical user interface, which is sufficient, but you can also install the full version.

Once you are done, don't plug in your SD card and boot your Hedgehog just yet, especially if you want to work headless.
Continue with the next section.

.. _Downloads: https://www.raspberrypi.org/downloads/raspbian/
.. _installation instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Headless Setup
^^^^^^^^^^^^^^


If you don't want to work using keyboard and monitor, continue here, otherwise, head over to "Headed Setup".

In a headless environment, network access is necessary to control a device.
SSH is a simple way to run commands from another machine; newer versions of Raspbian require you to `enable SSH`_ first as a security measure.
Follow the instructions for headless
The instructions also contain an overview of client software you can use on your computer.

Headed Setup
^^^^^^^^^^^^

Setting up SSH (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^

If you plan on using SSH, either now or later on, read on.
Otherwise, you can skip this.

Newer versions of Raspbian require you to `enable SSH`_ first; this is a security measure, as SSH allows remote access to a computer.
If you don't want to connect a monitor and keyboard, you will have to follow the instructions for "headless" devices,
otherwise you can choose one of both ways.
The instructions also contain an overview of client software you can use on your computer.

.. _enable SSH: https://www.raspberrypi.org/documentation/remote-access/ssh/

Connecting to the internet
^^^^^^^^^^^^^^^^^^^^^^^^^^

For installation of software only, Hedgehog requires an internet connection


Installing the Hedgehog firmware
--------------------------------
