Architecture
============

Hedgehog consists of two main pieces of hardware: high-level software runs on a Raspberry Pi (called software-controller, SWC).
The SWC is connected to a "shield" that grants access to actual robotics hardware.
At the core of this so-called hardware-controller (HWC) sits an STM32F4 microcontroller for time-critical and low-level tasks.

Hardware Controller
^^^^^^^^^^^^^^^^^^^

The HWC is responsible for

- providing a steady power supply from a 6V-19V power source;
- controlling servos and motors;
- connecting analog and digital sensors with optional pullup/pulldown resistors;
- providing additional connectors for serial buses, such as SPI
- some miscellaneous outputs: a buzzer and four status LEDs

Except for the power supply, the HWC's microcontroller makes these features accessible to the SWC over a UART connection.

Software Controller
^^^^^^^^^^^^^^^^^^^

The SWC's responsibilities lie mostly in software.
Hardware-wise, the Raspberry Pi's Ethernet and Wifi are used for connectivity, and additional peripherals such as webcams can be connected via USB.
In addition, the SWC connects to the HWC over both UART for communication and JTAG for debugging,
and includes additional connection pins for resetting the HWC microcontroller and other miscellaneous purposes.
Of course, keyboard, mouse and monitor can also be directly connected via USB and HDMI, respectively.

The SWC runs Raspbian as its operating system, and hosts the Hedgehog Server and Hedgehog Web IDE.
Hedgehog Server acts as an intermediary between client programs and the HWC.
It makes sure that all clients can access the hardware correctly, even if there are multiple clients,
and allows clients to connect bot locally and over the network using the Hedgehog Protocol.

The Hedgehog Web IDE is a web application that is hosted on the controller, meaning that an internet connection is not required for using Hedgehog.
Yet, using a browser-based development environment means that no installation is required and multiple operating systems can be supported with ease.
The Hedgehog IDE provides a visual Blockly programming environment and a Pyhon code editor (Ace) with syntax highlighting, code completion, folding and more.

This allows both beginners and intermediate users to write software easily.
For advanced users that prefer to write code in an IDE of their choice, Hedgehog can be accessed via SSH as well.
