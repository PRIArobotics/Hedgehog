.. _structure:

Project Structure
=================

Hedgehog's source files are divided into several repositories hosted on GitHub_.
This page shortly describes their roles and relations to each other.

.. _GitHub: https://github.com/PRIArobotics/
.. _Hedgehog_PCB: https://github.com/PRIArobotics/Hedgehog_PCB
.. _HedgehogCase: https://github.com/PRIArobotics/HedgehogCase
.. _HedgehogFirmware: https://github.com/PRIArobotics/HedgehogFirmware
.. _HedgehogPlatform: https://github.com/PRIArobotics/HedgehogPlatform
.. _HedgehogProtocol: https://github.com/PRIArobotics/HedgehogProtocol
.. _HedgehogUtils: https://github.com/PRIArobotics/HedgehogUtils
.. _hedgehog-ide: https://github.com/PRIArobotics/hedgehog-ide
.. _HedgehogServer: https://github.com/PRIArobotics/HedgehogServer
.. _HedgehogClient: https://github.com/PRIArobotics/HedgehogClient
.. _HedgehogNodeClient: https://github.com/PRIArobotics/HedgehogNodeClient
.. _Hedgehog: https://github.com/PRIArobotics/Hedgehog
.. _HedgehogBundle: https://github.com/PRIArobotics/HedgehogBundle
.. _HedgehogTester: https://github.com/PRIArobotics/HedgehogTester

.. _HedgehogProtocolSpec: https://github.com/PRIArobotics/HedgehogProtocolSpec
.. _HedgehogHWCFlasher: https://github.com/PRIArobotics/HedgehogHWCFlasher
.. _HedgehogGui: https://github.com/PRIArobotics/HedgehogGui

Hardware
--------

Hedgehog_PCB_
    KiCad schematics and layouts of Hedgehog's hardware controller.

HedgehogCase_
    3D models and SVG laser cutting files of Hedgehog's case.

HWC Software & Tools
--------------------

.. _repo-HedgehogFirmware:

HedgehogFirmware_
    Firmware to run on the HWC's STM32 microcontroller, written in C.

Common Python Packages
----------------------

.. _repo-HedgehogUtils:

HedgehogUtils_
    Collection of Python utilities for Hedgehog, but not specific to a particular part of the software.
    Utilities are mostly for Protocol Buffers and ZeroMQ,

.. _repo-HedgehogPlatform:

HedgehogPlatform_
    Python library that detects the "platform" that Hedgehog software is run on, i.e. the kind of software controller used,
    and provides platform independent interfaces on top of features that differ by platform.
    Right now, the only feature that is abstracted in this way is access to the HWC,
    used by :ref:`HedgehogServer <repo-HedgehogServer>`.

    The only platform that is currently used for Hedgehog is the Raspberry Pi 3.
    In the past, an Orange Pi 2 was used instead.
    As there is only one platform in use at the moment, and it is hard to anticipate what platform differences may arise,
    this repository's code is currently somewhat stale.

.. _repo-HedgehogProtocol:

HedgehogProtocol_
    Contains protocol buffers definitions and Python classes for the Hedgehog Protocol.
    In addition to the classes generated from the protobuf definition, this repository contains:

    - Exception classes that correspond to error acknowledgement codes
    - Wrapper classes that correspond to Hedgehog protocol messages:
      a single protobuf message type may correspond to multiple Hedgehog message types;
      for example, sensor requests and sensor replies are transported as the same message type.
      The wrapper classes convey what Hedgehog message is represented, and provide message-specific validation.
    - helpers for working with Hedgehog protocol messages over ZeroMQ sockets,
      such as sockets that encode and decode single- or multipart messages.

    HedgehogProtocol depends on :ref:`HedgehogUtils <repo-HedgehogUtils>` for its ZeroMQ and Protobuf capabilities.

Server Software
---------------

.. _repo-HedgehogServer:

HedgehogServer_
    Serves clients that use the Hedgehog protocol.
    The server is written in Python and builds on :ref:`HedgehogProtocol <repo-HedgehogProtocol>`.
    To handle client requests, the server communicates with the HWC,
    utilizing :ref:`HedgehogPlatform <repo-HedgehogPlatform>` to determine how to do that.

.. _repo-hedgehog-ide:

hedgehog-ide_
    Hedgehog's web IDE.
    The server part uses Node.js, the browser side Angular 4; both parts are written in TypeScript.
    To communicate with the :ref:`HedgehogServer <repo-HedgehogServer>`, :ref:`HedgehogNodeClient <repo-HedgehogNodeClient>` is used.

Client Software
---------------

HedgehogClient_
    Python client library for Hedgehog.
    The library builds on top of :ref:`HedgehogProtocol <repo-HedgehogProtocol>`.

.. _repo-HedgehogNodeClient:

HedgehogNodeClient_
    Node.js client library for Hedgehog.
    At the moment, this library also includes the protocol implementation for Node.js.
    The :ref:`hedgehog-ide <repo-hedgehog-ide>` uses this to communicate to the :ref:`HedgehogServer <repo-HedgehogServer>`.

Miscellaneous
-------------

Hedgehog_
    Contains this documentation, and also a Makefile that serves as the entry point into Hedgehog software installation.

.. _repo-HedgehogBundle:

HedgehogBundle_
    Bundles installation scripts into one repository.
    The bundle contains folders for installations of Python, Node, OpenCV, protoc,
    the HWC firmware, server, IDE, client, and boot service.

HedgehogTester_
    A simple client program that helps testing all of Hedgehog's hardware.
