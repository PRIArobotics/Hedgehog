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
