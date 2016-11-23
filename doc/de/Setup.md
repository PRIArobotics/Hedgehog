# Vorbereiten eines Raspberry Pi

Dieses Dokument soll beschreiben, wie man eine MicroSD-Karte für die Verwendung für Hedgehog Light vorbereitet.

> Für den SHARK Unterwasser-Roboter unterstützen wir noch den Orange Pi 2.
> Diese Anleitung geht nicht auf die Details des Orange Pi ein,
> enthält aber die relevanten Unterschiede bei der Installation.

## Originales Image auf SD-Karte spielen

Wir verwenden Raspbian für den Raspberry Pi 3.
[Hier](https://www.raspberrypi.org/downloads/raspbian/) gibt es Download-Links für die Lite- sowie Desktop-Version.
Die Lite-Version hat keine grafische Benutzeroberfläche, was für eine normale des Hedgehogs auch nicht notwendig ist.
Raspbian kann auch über BitTorrent heruntergeladen werden.

> für den Orange Pi 2 wird Armbian benutzt.
> [Hier](http://www.armbian.com/orange-pi-2/) gibt es Download-Links für die
> [Server](http://mirror.igorpecovnik.com/Armbian_5.05_Orangepih3_Debian_jessie_3.4.110.zip)- sowie
> [Desktop](http://mirror.igorpecovnik.com/Armbian_5.05_Orangepih3_Debian_jessie_3.4.110_desktop.zip)-Vesion.

Installationsanleitungen gibt es [hier](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

## Inbetriebnahme

Details zur Verwendung des Pi (Ethernet, UART-Konsole, SSH) finden sich im [nächsten Dokument](01-Working.md).
Die dortigen Anweisungen sind auch hier gültig.

Für die folgenden Setup-Schritte ist eine Internet-Verbindung notwendig.

## Makefile bereitstellen

Am einfachsten lädt man das benötigte Makefile direkt auf den Pi herunter:

    cd
    curl -O https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/Makefile
    # oder: wget https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/Makefile

Alternativ kann man das [Makefile](https://raw.githubusercontent.com/PRIArobotics/HedgehogLightSetup/master/Makefile) vor dem ersten Starten auf die SD-Karte (nach `/home/pi`) laden.

## Setup ausführen

Das Setup-Skript wird folgendermaßen ausgeführt:

    cd
    make rpi-setup
    # bzw. für Orange Pi (Legacy support für SHARK):
    make opi-setup

Anschließend muss der Raspberry Pi neu gestartet werden, um die Aktivierung der UART-Schnittstelle anzuweden.
Die UART-Schnittstelle ist zum Installieren der HWC-Firmware notwendig.

    sudo reboot

Nach dem Neustart wird die eigentliche Hedgehog Light Software installiert:

    cd
    make python-setup server-setup firmware-setup

**TODO** `with-raspberry`

**TODO** Setups von Firmware-Installation trennen

Die folgenden Schritte werden durch das Setup erledigt:

### `rpi-setup`

* Locale einrichten

  Die einzige standardmäßig aktivierte Locale ist `en_US.UTF-8`.
  Wenn man sich per SSH mit dem Controller verbindet, wird aber die Locale des sich verbindenden Systems übernommen, z.B. `de_AT.UTF-8`.
  Die dann aktive Locale ist also im System nicht aktiviert!
  Das kann bei manchen Programmen zu Problemen führen, von Warnungen bishin zur fehlerhaften Ausführung.

  Um Fehler und Warnungen im nachfolgenden Setup zu vermeiden, wird direkt die aktuelle Locale eingerichtet.
  Verbindet man sich später über einen anderen Rechner, kann man mit `make fix_locale` diesen Schritt für die möglicherweise andere Locale wiederholen.

* Partition erweitern

  Bevor zusätzliche Software installiert wird, wird die Root-Partition an die Laufwerksgröße angepasst.

* Serielle Verbindung aktiviert

  Die Serielle Verbindung (UART) wird zur Kommunikation mit der Hardware-Platine benutzt.
  Sie ist in Raspbian nach der Neuinstallation noch nicht aktiviert.

* Software aktualisieren

  Es werden die Paketquellen aktualisiert sowie Updates installiert

* `git` installieren

  Außer dem Setup-Makefile wird Hedgehog-Software über `git` heruntergeladen, daher wird dieses Tool installiert.

  **TODO** Zugriff auf andere IOs (SPI, …) ohne Root-Rechte ermöglichen/testen

### `python-setup`

Ein Großteil der Hedgehog Software basiert auf Python, das hiermit installiert wird.

### `server-setup`

Hiermit wird der Hedgehog Server installiert.
Dabei werden die benötigten Python-Pakete in einem Vitual Environment installiert.
Statt `server-setup` kann auch `server-develop-setup` benutzt werden;
damit wird eine noch nicht veröffentlichte Version installiert werden.

> **Achtung:** Die develop-Versionen sind generell weniger gut getestet als die offiziell veröffentlichten!

### `firmware-setup`

Hiermit wird die HWC Firmware installiert.
Statt `firmware-setup` kann auch `firmware-develop-setup` benutzt werden;
damit wird eine noch nicht veröffentlichte Version installiert werden.

> **Achtung:** Die develop-Versionen sind generell weniger gut getestet als die offiziell veröffentlichten!

## (optional) Drahtlosnetzwerk einrichten

Auf dem Raspberry Pi ist WPA supplicant installiert.
Damit kann eine WLAN-Verbindung hergestellt werden, auch über die command line.

So wird zum Beispiel eine Verbindung mit dem TGM-Netzwerk (WPA Enterprise) hergestellt:

    sudo wpa_cli
    > add_network
    0
    > set_network 0 ssid "TGM1x"
    OK
    > set_network 0 key_mgmt WPA-EAP
    OK
    > set_network 0 eap PEAP
    OK
    > set_network 0 identity "username"
    OK
    > set_network 0 password "password"
    OK
    > enable_network 0
    OK
    ...
    > save_config
    OK

Eine Verbindung mit einem WPA Personal Netzwerk wird folgendermaßen hergestellt:

    sudo wpa_cli
    > add_network
    1
    > set_network 1 ssid "SSID"
    OK
    > set_network 1 key_mgmt WPA-PSK
    OK
    > set_network 1 psk "secret"
    OK
    > enable_network 1
    OK
    ...
    > save_config
    OK

Mehr Informationen zu `wpa_cli` und den möglichen `set_network`-Optionen erhält man über

    man wpa_cli
    man wpa_supplicant.conf
