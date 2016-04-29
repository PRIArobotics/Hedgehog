# HWC-Entwicklung

Dieses Dokument soll beschreiben, wie direkt auf dem Orange Pi Software für den verbundenen STM32-Microcontroller Software entwickelt werden kann.
Unten wird weiters beschrieben, wie mit einer anderen Entwicklungsmaschine Programme über den Orange Pi auf den Microcontroller geladen werden können.

## C-Toolchain

Zum Kompilieren und Linken von C-Programmen für den Controller benötigt man die entsprechende Toolchain.
Die Toolchain kann auf dem Orange Pi, oder auf einem anderen Debian-basierten System, wie folgt installiert werden.

    sudo apt-get -y install gcc-arm-none-eabi
    # Auf ARM-Systemen wie dem Orange Pi scheint man auch dieses Paket zu benötigen,
    # siehe https://stackoverflow.com/questions/23973971/no-stdint-h-file-on-debian:
    sudo apt-get -y install libnewlib-arm-none-eabi

## Hedgehog Firmware Bundle

Zum Entwickeln der Hedgehog Firmware gibt es das [Hedgehog Firmware Bundle](https://github.com/PRIArobotics/HedgehogFirmwareBundle),
mit dem die Hedgehog-Firmware bequem entwickelt werden kann.
Das Bundle enthält den HWC Flasher und die Firmware als git-Submodules.
Mit kleinen Modifikationen im Makefile können damit auch eigene Projekte entwickelt und installiert werden.

Der Enthaltene HWC-Flasher benötigt eine [Python-Installation](python.md).

    # Installation - einmalig notwendig
    git clone https://github.com/PRIArobotics/HedgehogFirmwareBundle.git
    cd HedgehogFirmwareBundle
    git submodule init
    git submodule update
    make env
    # Firmware kompilieren
    make
    # Firmware installieren
    make flash
    # Firmware-Projekt aufräumen
    make clean

Das Firmware-Projekt (nicht das Bundle!) enthält außerdem ein Make-Target zum Flashen über das Netzwerk.
Dazu muss auf dem Controller das Bundle in /home/hedgehog/HedgehogFirmwareBundle installiert sein:

    # lokal kompilierte Firmware auf Hedgehog-Controller installieren
    make remote-flash
