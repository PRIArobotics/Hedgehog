# STM32-Entwicklung

Dieses Dokument soll beschreiben, wie direkt auf dem Orange Pi Software für den verbundenen STM32-Microcontroller Software entwickelt werden kann.
Unten wird weiters beschrieben, wie mit einer anderen Entwicklungsmaschine Programme über den Orange Pi auf den Microcontroller geladen werden können.

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

## Flasher

Unabhängig davon, wie man seine Programme entwickelt, muss man das `.bin`-File am Ende auf den Microcontroller laden.
das Passiert mit dem [`STM32Flasher`](https://github.com/PRIArobotics/STM32Flasher).

Die folgende Software muss zunächst installiert werden:

* [Python](python.md)

* `git`

        sudo apt-get -y install git

Der Flasher kann folgendermaßen in einem beliebigen Verzeichnis installiert werden.
Anschließend wird ein Symlink erstellt, damit der Flasher direkt aufgerufen werden kann.

    python3 -m virtualenv flasher
    . flasher/bin/activate
    pip install git+git://github.com/PRIArobotics/STM32Flasher.git
    deactivate
    sudo ln -s `realpath flasher/bin/stm32flasher` /usr/local/bin/

## C-Toolchain

Zum Kompilieren und Linken von C-Programmen für den Controller benötigt man die entsprechende Toolchain.
Die Toolchain kann auf dem Orange Pi, oder auf einem anderen Debian-basierten System, wie folgt installiert werden.

Die folgende Software muss zunächst installiert werden:

* Für den STM32-Microcontroller benötigt man die GCC-ARM-Toolchain.

* Zusätzlich benötigt man den `unzip`-Befehl zum Entpacken der Standard Library.

    sudo apt-get -y install build-essential gcc-arm-none-eabi unzip

### STM32F303VCT6

Hedgehog basierte auf dem STM32F3 Discovery Board, das einen STM32F303VCT6 verbaut.
Wir stellen eine [Vorlage](https://github.com/PRIArobotics/STM32Template) für Projekte mit diesem Mikrocontroller zur Verfügung.

Das Makefile automatisiert die folgenden Setup-Schritte:

1. Standard Peripheral Library herunterladen und Entpacken

   Dies kann [hier](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1939/PF258144#orderable) heruntergeladen werden.
   Bitte beachte die darin angegebenen Lizenzbedingungen.

2. Kopieren der `.c`- und `.h`-Files der Projektvorlage nach `src` bzw. `inc`

   Diese befindet sich im folgenden Ordner:

        STM32F30x_DSP_StdPeriph_Lib_V.../Projects/STM32F30x_StdPeriph_Templates/

Automatisiert:

    # löscht ein heruntergeladenes Archiv und lädt es erneut herunter
    make download
    # löscht den entpackten Archiv-Inhalt und entpackt das Archiv erneut
    make unpack
    # Erstellt Ordner src und inc & kopiert die .c- und .h-Vorlage-Dateien dort hin.
    make template

Das Makefile referenziert alle benötigten Bibliotheken und stellt die folgenden wichtigen Targets zur Verfügung:

    # Löscht alle Binärdateien, etwa .o-, .elf-, .bin- und .map-Dateien
    make clean
    # Kompiliert und linkt das Programm. Das Ergebnis ist eine .bin-Datei
    make
    # Lädt das Programm auf den Microcontroller
    # Der Flasher muss als `stm32flasher` aufrufbar sein.
    make flash

### STM32F4

[STM32F4xx](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1939/PF257901#orderable).

**TODO**

### Example-Projekt

[Hier](https://github.com/PRIArobotics/STM32Example) gibt es ein Beispiel-Projekt das die beschriebene Toolchain benutzt.
Man kann die Toolchain folgendermaßen verifizieren:

    git clone https://github.com/PRIArobotics/STM32Example.git
    cd STM32Example/
    # Nur einmal nach dem Klonen notwendig
    make download && make unpack
    # Für jede Änderung
    make && make flash

`make template` ist nur notwendig, wenn man das Template-Projekt als Vorlage für ein komplett neues Projekt benutzt.
Anwendungsprojekte, wie das Example-Projekt, enthalten bereits die durch `make template` kopierten Dateien, und mehr.

Wenn alles funktioniert, sollten die LEDs an `PE14` und `PE15` mit 1Hz blinken.

## Entwickeln auf einer anderen Maschine

Oft ist es wünschenswert, auf einer anderen Maschine zu entwickeln:
Komfortablere Entwicklungsumgebung, schnelleres kompilieren, ...

Dazu muss die vorgestellte (oder eine andere) Toolchain auf diesem Gerät installiert werden.
Der Flasher muss auf dem Orange Pi installiert sein.
Sobald man ein `.bin`-File hat, kann man es folgendermaßen auf den Microcontroller spielen:

    rsync -avz $NAME.bin orangepi@10.42.0.226:/tmp/
    ssh orangepi@10.42.0.226 stm32flasher /tmp/$NAME.bin

Dafür gibt es im Template-Projekt schon ein Target:

    make remote-flash

