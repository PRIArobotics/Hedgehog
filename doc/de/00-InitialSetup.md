# Vorbereiten eines Orange Pi

Dieses Dokument soll beschreiben, wie man eine MicroSD-Karte für die Verwendung für Hedgehog Light vorbereitet.

## Originales Image auf SD-Karte spielen

Wir verwenden Armbian für den Orange Pi 2.
[Hier](http://www.armbian.com/orange-pi-2/) gibt es Download-Links für die
[Server](http://mirror.igorpecovnik.com/Armbian_5.05_Orangepih3_Debian_jessie_3.4.110.zip)- sowie
[Desktop](http://mirror.igorpecovnik.com/Armbian_5.05_Orangepih3_Debian_jessie_3.4.110_desktop.zip)-Vesion.

Die Installation funktioniert wie auch bei einem Raspberry Pi, Anleitungen gibt es [hier](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).
Nach dem Download und entpacken wird es mit geeigneter Software auf eine MicroSD-Karte gespielt.

## Armbian zum ersten mal starten

Details zur Verwendung des Pi (Ethernet, UART-Konsole, SSH) finden sich im [nächsten Dokument](01-Working.md).
Die dortigen Anweisungen sind auch hier gültig.

Nach dem ersten Login (Username: `root`, Passwort: `1234`) muss das Root-Passwort geändert und ein zweiter Benutzer ertellt werden.
Folge dazu den Anweisungen am Bildschirm.

Wir gehen in weiterer Folge davon aus, dass der neue Benutzer `hedgehog` genannt wurde
und sein Home-Verzeichnis `/home/hedgehog` ist.
Für Entwicklungsgeräte empfehlen wir `hedgehog`/`hedgehog` als Login-Daten.

Logge dich am besten Sofort aus dem Root-Accout aus (`^D`, `exit` oder `logout`) und benutze `hedgehog` für alle weiteren Schritte.

## Setup-Dateien bereitstellen

Am einfachsten klont man dieses git-Repository direkt nach `/home/hedgehog`:

    git clone https://github.com/PRIArobotics/HedgehogLightSetup.git

Alternativ kann man das Repository [als zip-Datei herunterladen](https://github.com/PRIArobotics/HedgehogLightSetup/archive/master.zip) und auf die SD-Karte entpacken.

## Setup ausführen

Im folgenden wird davon ausgegangen, dass die Setup-Dateien auf der Karte unter `/home/hedgehog/HedgehogLightSetup` liegen.
Das Setup-Skript wird folgendermaßen mit Root-Rechten ausgeführt:

    cd /home/hedgehog/HedgehogLightSetup
    chmod a+x setup.sh
    sudo ./setup.sh

Die folgenden Aufgaben werden durch das Skript erledigt:

* Software aktualisieren

  Es werden die Paketquellen aktualisiert sowie Updates installiert:

* `/boot/bin/orangepi2.bin` ersetzen

  Das Original konfiguriert einige Pins nicht so, wie wir es benötigen, wodurch UARTs und GPIOs nicht gleichzeitig funktionieren.
  Außerdem ist UART1 standardmäßig nicht aktiviert.
  Weiters konfigurieren wir alle UARTs für Mode 2 ohne `CTS`/`RTS`.

  Das neue `script.bin` wird direkt auf dem Pi aus `res/orangepi2.fex` erstellt, es können also vor Ausführung des Skripts noch Anpassungen vorgenommen werden.
  Das Originale Skript, auf dem das von uns bereitgestellte basiert, ist [hier](https://github.com/igorpecovnik/lib/blob/master/config/orangepi2.fex) verfügbar.

* Kernelmodul `gpio-sunxi` in `/etc/modules` aktivieren

  Dadurch werden die GPIOs über das `sysfs` verfügbar.

* Dem `hedgehog`-User Zugriff auf IOs geben

  Der User mit der Kennung 1000 wird der Gruppe `gpio` hinzugefügt.
  Sofern diese Anleitung befolgt wurde, ist das der Benutzer, der nach der Installation erstellt wurde (der Benutzername ist egal).
  Durch ein Startup-Script wird den notwendigen Dateien diese Gruppe zugewiesen.

  Der User ist schon von vornherein Teil der `dialout`-Gruppe, wodurch er Zugriff auf die USARTs hat.

  **TODO** Zugriff auf andere IOs (SPI, …) ohne Root-Rechte ermöglichen/testen

* `network-manager` installieren

  Mit dem Network Manager können Netzwerkverbindungen einfach verwaltet werden.
  
  __Falls die Verbindung über SSH hergestellt wurde, wird sie während diesem Schritt abbrechen!__

* Ein Neustart: `reboot`

## (optional) Drahtlosnetzwerk einrichten

Durch das Setup wurde unter anderem `network-manager` installiert.
Damit können sowohl über die Konsole, als auch über eine grafische Oberfläche
(falls vorhanden), Netzwerke konfiguriert werden.

Die folgenden Befehle helfen beim Verbinden mit einem Drahtlosnetzwerk:

    # Erklärt nmcli WIFI-Kommandos
    nmcli device wifi help
    # Listet Netzwerke auf
    nmcli device wifi list
    # Stellt eine Verbindung her. Siehe auch `nmcli device wifi help`
    nmcli device wifi connect SSID password PASSWORD

## Aufräumen

Die Setup-Dateien können abschließend vom Pi gelöscht werden.

    cd /home/hedgehog
    rm -rf HedgehogLightSetup

