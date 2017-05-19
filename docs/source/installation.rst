Installation
============

This document describes how to install the software that runs on a Hedgehog controller.
If you have bought a complete controller, it should have come with everything installed and you shouldn't have to do this.
If you somehow can't connect to your controller anymore, you can re-install everything as described here as a last resort.

Using a Hedgehog SD card image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO

Installing from scratch
^^^^^^^^^^^^^^^^^^^^^^^

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
We provide instructions for both

Installing Raspbian
-------------------

Like any Raspberry Pi, Hedgehog needs an operating system.
Downloads_ and `installation instructions`_ can be found at raspberrypi.org.

To follow the rest of the installation, you will need to be able to run commands on your Hedgehog.
There are basically two ways for this:

- connect a keyboard and a monitor, or
- connect to your Hedgehog via SSH.

If you plan on using SSH, either now or later on, continue with the next section.
Otherwise, you can skip it.

.. _Downloads: https://www.raspberrypi.org/downloads/raspbian/
.. _installation instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Setting up SSH (optional)
-------------------------

Newer versions of Raspbian require you to `enable SSH`_ first; this is a security measure, as SSH allows remote access to a computer.
If you don't want to connect a monitor and keyboard, you will have to follow the instructions for "headless" devices,
otherwise you can choose one of both ways.
The instructions also contain an overview of client software you can use on your computer.

.. _enable SSH: https://www.raspberrypi.org/documentation/remote-access/ssh/

Connecting to the internet
--------------------------

For installation of software only, Hedgehog requires an internet connection


Installing the Hedgehog firmware
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
