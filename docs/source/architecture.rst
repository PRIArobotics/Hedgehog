.. _architecture:

Architecture
============

Hedgehog consists of two main pieces of hardware: high-level software runs on a Raspberry Pi (called software-controller, SWC).
The SWC is connected to a "shield" that grants access to actual robotics hardware.
At the core of this so-called hardware-controller (HWC) sits an STM32F4 microcontroller for time-critical and low-level tasks.

.. _architecture-hwc:

Hardware Controller
-------------------

The HWC is responsible for

- providing a steady power supply from a 6V-19V power source;
- controlling servos and motors;
- connecting analog and digital sensors with optional pullup/pulldown resistors;
- providing additional connectors for serial buses, such as SPI;
- some miscellaneous outputs: a buzzer and four status LEDs.

Except for the power supply, the HWC's microcontroller makes these features accessible to the SWC over a UART connection.

.. _architecture-swc:

Software Controller
-------------------

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

.. _architecture-protocol:

Protocol
--------

When users write their robot programs, they of course need to access the robot's hardware somehow.
With Hedgehog, this is done by connecting to the Hedgehog Server and communicating using Hedgehog Protocol messages.
Usually the client program will run on the controller and connect locally, but that is not required.

Once a client has initiated communication, both ends can send data at any time.
Requests by clients are answered with a dedicated response, or a generic acknowledgement.
In certain cases, the server may send additional updates after that.
For example, after starting a child process, the server will send a message to the client when that process terminated.

The Hedgehog Protocol is based on ZeroMQ_ and Protobuf_:
ZeroMQ is a message queue library that makes it easy to do asynchronous and reliable networking,
while Protobuf provides efficient and extensible serialization of datatypes.
At the same time, both technologies support various programming languages.
This makes it easy to implement the Hedgehog protocol in C, C++, C#, Go, Haskell, PHP, or Ruby, to name a few.
Implementations in Python, node.js and Scala already exist, with the Python version being the most mature.

.. _ZeroMQ: http://zeromq.org/
.. _Protobuf: https://developers.google.com/protocol-buffers/

.. _architecture-apis:

Client APIs
-----------

While using the Hedgehog Protocol directly is the most flexible way of accessing Hedgehog's hardware,
most people will use an API that provides a higher level of abstraction.
Goals of a client API implementation should be:

- clean and preferably asynchronous implementation of the Hedgehog Protocol;
- making all features of Hedgehog accessible to the API's users;
- providing a further, possibly limited set of APIs that are easy to use;
- achieving these in a way that fits the spirit and intent of the programming language.

The last of these goals means that Hedgehog APIs in different languages are not necessarily meant to look the same.
Each implementation should use the features and conventions of their language, so that using the API feels "right".
It would not make sense to force the structure of a great C API onto a Haskell one;
learning proper Haskell with such a library would not work, and experienced Haskell programmers would get frustrated.
