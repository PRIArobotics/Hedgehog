# STM32-Entwicklung

Dieses Dokument soll beschreiben, wie direkt auf dem Orange Pi Software für den verbundenen STM32-Microcontroller Software entwickelt werden kann.

## Anschlüsse

Dieser Abschnitt wird mit den ersten gefertigten Boards obsolet werden.

Die Pins am Orange Pi sind nicht beschriftet. Hier sind die Pins aufgelistet, wobei sich neben Pin 1 am Pi ein kleiner Pfeil befindet. Neben den roten Pins sind 5V und GND relevant.

![Orange Pi Pinout](../res/orangepi_pinout.png)

Die Zuordnung ist wie folgt:

         Pi --- STM32
         GND … GND
          5V … 5V
         PA7 … BOOT0
         PA8 … NRST
    UART3_TX … PA10
    UART3_RX … PA9

## Flashen

Zum Flashen kann der [STM32Flasher](https://github.com/PRIArobotics/STM32Flasher) verwendet werden.
Hier ein schneller Überblick zur Installation:

* Für den Flasher wird [Python](python.md) benötigt.

* `git` ist auf dem Orange Pi nicht vorinstalliert, wird aber zur Installation von `STM32Flasher` benötigt (und ist auch ansonsten bei der Software-Entwiclung sehr nützlich):

        sudo apt-get -y install git

* Danach installiert man wie beschrieben `STM32Flasher`:

        python3 -m virtualenv env
        . env/bin/activate
        pip install git+git://github.com/PRIArobotics/STM32Flasher.git
        deactivate

* Nun kann man seine Programme auf den STM32 spielen (das Environment muss dazu nicht aktiviert sein):

        sudo env/bin/stm32flasher "$FILE"

## Toolchain

**TODO**

