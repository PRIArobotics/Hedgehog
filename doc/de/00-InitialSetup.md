# Vorbereiten eines Orange Pi

Dieses Dokument soll beschreiben, wie man eine MicroSD-Karte für die Verwendung für Hedgehog Light vorbereitet.

## Originales Image auf SD-Karte spielen

Wir verwenden `OrangePI-PC_Ubuntu_Vivid_Mate.img`, zu dem es auf folgender Seite Download-Links zu mega.nz und Google Drive gibt:

<http://www.orangepi.org/orangepibbsen/forum.php?mod=viewthread&tid=342>

**TODO:** auf webspace.pria.at bereitstellen?

Das Image ist xz-komprimiert und muss noch entpackt werden, dann wird es mit geeigneter Software auf eine MicroSD-Karte gespielt.

#### Linux/Mac

Zum Entpacken kann man `xz` verwenden:

    xz -dk OrangePI-PC_Ubuntu_Vivid_Mate.img.xz

Dann muss man die SD-Karte finden. Dabei hilft beispielsweise `fdisk`:

    sudo fdisk -l | grep -oE '/dev/.*:' | sed 's/://'
    #Output Beispiel:
    # /dev/sda
    # /dev/mmcblk0

Wobei `/dev/sda` die Festplatte ist, `/dev/mmcblk0` also die SD-Karte.
Dann kann man die SD-Karte (nicht eine eventuell darauf befindliche Partition wie etwa `/dev/mmcblk0p1`!) mit `dd` beschreiben.

**Wichtig:** wenn man `sudo dd` im Hintergrund ausgeführt wird und ein Passwort verlangt, wird auch die Passwortabfrage im Hintergrund ausgeführt.
In diesem Fall startet man den Befehl am besten im Vordergrund (ohne `&`) und gibt das Passwort ein.
Anschließend kann man den Prozess mit `^Z`, `bg 1` in den Hintergrund verschieben.

Man kann `dd` signalisieren, dass es den aktuellen Fortschritt ausgeben soll:

    sudo dd if=OrangePI-PC_Ubuntu_Vivid_Mate.img of=<Device> & #dd im Hintergrund ausführen
    PID=$!

    sudo kill -USR1 $PID
    #Output Beispiel:
    # 275537+0 records in
    # 275537+0 records out
    # 141074944 bytes (141 MB) copied, 24,2606 s, 5,8 MB/s

Den `sudo kill` Befehl kann man immer wieder aufrufen, wenn man den aktuellen Fortschritt wissen will.

#### Windows: TODO

## Zusätzliche Dateien auf die Karte spielen

Nach dem Formatieren kann man die SD-Karte einhängen, und die später erforderlichen Setup-Dateien darauf kopieren.
Da es sich um eine ext4-Partition handelt, geht das nicht unter Windows.

Am einfachsten klont man dieses git-Repository auf die SD-Karte:

    git clone https://github.com/PRIArobotics/HedgehogLightSetup.git

Alternativ kann man das Repository [als zip-Datei herunterladen](https://github.com/PRIArobotics/HedgehogLightSetup/archive/master.zip) und auf die SD-Karte entpacken.

## Änderungen anwenden

Im folgenden wird davon ausgegangen, dass die Setup-Dateien auf der Karte unter `/home/orangepi/HedgehogLightSetup` liegen.

Details zur Verwendung des Pi (Ethernet, UART-Konsole, SSH, Login-Daten) finden sich im [nächsten Dokument](01-Working.md).
Die dortigen Anweisungen sind auch hier gültig, mit der Ausnahme, dass Ethernet erst in Phase 2 funktioniert.

### Phase 1

Nun legt man die SD-Karte in den Pi ein, bootet, und loggt sich ein.
Anschließend führt man das 1. Setup-Skript mit Root-Rechten aus:

    cd /home/orangepi/HedgehogLightSetup
    chmod a+x setup_phase1.sh
    sudo ./setup_phase1.sh

Die folgenden Aufgaben werden durch das Skript erledigt:

* Partition vergrößern mit `sudo fs_resize`

  Das Image füllt nicht die Ganze Karte aus; hier wird die Partitionsgröße an die Karte angepasst.

* DHCP für `eth0` automatisch aktivieren

  Damit der Pi über Ethernet später automatisch eine Adresse erhält, wird eine Datei in `/etc/network/interfaces.d/` erstellt.

* Ein Neustart: `reboot`

  Der Neustart ist notwendig, damit die Änderung der Partitionsgröße wirksam wird und zusätzliche Software installiert werden kann.

### Phase 2

Der Pi benötigt jetzt Internet, deshalb muss er an ein LAN mit DHCP angeschlossen werden.
In Phase 2 kann man sich auch per SSH einloggen.
Nun führt man das 2. Setup-Skript mit Root-Rechten aus:

    cd /home/orangepi/HedgehogLightSetup
    chmod a+x setup_phase2.sh
    sudo ./setup_phase2.sh

Die folgenden Aufgaben werden durch das Skript erledigt:

* Software installieren

  Es werden Updates und benötigte Software installiert:

  `sunxi-tools`: zum Erstellen von `script.bin`

* `/media/boot/script.bin` ersetzen

  Das Original konfiguriert einige Pins nicht so, wie wir es benötigen, wodurch UARTs und GPIOs nicht gleichzeitig funktionieren.
  Außerdem ist UART1 standardmäßig nicht aktiviert.
  Weiters konfigurieren wir alle UARTs für Mode 2 ohne `CTS`/`RTS`.

  Das neue `script.bin` wird direkt auf dem Pi aus `res/orange_pi2.fex` erstellt, es können also vor Ausführung des Skripts noch Anpassungen vorgenommen werden.
  Das Originale Skript, auf dem das von uns bereitgestellte basiert, ist [hier](https://github.com/loboris/OrangePi-BuildLinux/blob/master/orange/orange_pi2.fex) verfügbar.

* Kernelmodul `gpio-sunxi` in `/etc/modules` aktivieren

  Dadurch werden die GPIOs über das `sysfs` verfügbar.

* Dem `orangepi`-User Zugriff auf IOs geben

  Der User wird der Gruppe `gpio` hinzugefügt.
  Durch ein Startup-Script wird den notwendigen Dateien diese Gruppe zugewiesen.

  Der User ist schon von vornherein Teil der `dialout`-Gruppe, wodurch er Zugriff auf die USARTs hat.

  **TODO** Zugriff auf andere IOs (SPI, …) ohne Root-Rechte ermöglichen/testen

* Ein Neustart: `reboot`

## Aufräumen

Die Setup-Dateien können abschließend vom Pi gelöscht werden.

    cd /home/orangepi
    rm -rf HedgehogLightSetup

