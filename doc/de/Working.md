# Inbetriebnahme

Diese Anleitung zeigt, wie man sich auf dem im Hedgehog Light verbauten Raspberry Pi anmeldet.
In den meisten Fällen ist das nicht notwendig, da über eine IDE bzw. das Hedgehog-Protokoll auf den Controller zugegriffen wird.
Diese Anleitung ist für jene, die einen Hedgehog frisch installieren oder vollen Zugriff erlangen wollen.

Die Stromversorgung eines Hedgehogs erfolgt über den Stromanschluss mit einem LiPo-Akku oder ein Netzteil (7.4V).
Ein Raspberry Pi ohne Hardware-Platine kann über den MicroUSB-Anschluss mit Strom versorgt werden.

> **Achtung:** Ein Raspberry Pi mit Hardware-Platine kann **nicht** über MicroUSB mit Strom versorgt werden.

Zusätzlich braucht man noch Eingabe- und Ausgabemöglichkeiten; Benutzername und Passwort lauten (standardmäßig) `pi`/`raspberry`.

> Beim Orange Pi lauten die Daten `root`/`1234`.
> Als erster Schritt wird dann das Root-Passwort geändert und ein zusützlicher Benutzer angelegt.
> Wir empfehlen `pi`/`raspberry` oder `hedgehog`/`hedgehog`, wenn keine Zugangsbeschränkung benötigt wird.

## Direkt

Maus, Tastatur (USB) & Bildschirm (HDMI) anstecken, an der grafischen Oberfläche oder Konsole anmelden.

## Über SSH

Der Raspberry Pi ist konfiguriert, über seinen Ethernet-Port per DHCP eine Adresse zu beziehen,
also kann man sich über Ethernet mit dem Pi verbinden und auch Internet für ihn freigeben.
Danach benötigt man noch die IP-Adresse des Pi, und verbindet sich über SSH.

### Ethernet-Freigabe

#### Ubuntu

*Network Connections* > (geeignete Ethernet-Konfiguration) > *Edit* > *IPv4 Settings* > *Method: Shared to other computers*

#### Linux/Mac: TODO

#### Windows

Eine Möglichkeit unter Windows ist, beiden Geräten eine statische IP-Adresse zu geben.
Am Raspberry Pi editiert man dazu `cmdline.txt` in der Boot-Partition.
Das ist eine FAT-Partition, diese wird also auch unter Windows erkannt.

> Der Pi sollte davor schon einmal gestartet haben!

Am Ende der Datei wird `ip=169.254.0.2` hinzugefügt.
Die Datei sieht dann etwa so aus:

    dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait ip=169.254.0.2

Dann wird unter Windows der Ethernet-Adapter konfiguriert:

*Netzwerk- und Freigabecenter* > *Adaptereinstellungen ändern* > Ethernet > *Eigenschaften* > *TCP/IPv4* > *Alternative Konfiguration*

Dort wird als IP-Adresse `169.254.0.1` und als Netzwerkmaske `255.255.255.0` ausgewählt.

### WIFI: TODO

### IP-Adresse ermitteln

Wenn man auch anders am Pi angemeldet ist, kann man direkt nachschauen:

    ifconfig eth0 | \
      grep -oE 'inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/inet addr://'

Wenn die Hedgehog-Software schon auf dem Pi installiert ist, kann man die IP-Adresse über die Discovery ermitteln.

Wenn man selbst die Verbindung freigibt (über Ethernet oder WIFI), kann man die Adresse eventuell anders ermitteln, zum Beispiel:

#### Linux/Mac

> Ein Gesamtskript folgt am Ende dieses Abschnitts

Zuerst die eigene IP-Adresse ermitteln, z.B. (ggf. muss man das Interface ändern):

    ifconfig enp9s0 | \
      grep -oE 'inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/inet addr://'

Wenn diese zum Beispiel `10.42.0.1` ist, dann

    for IP in 10.42.0.{1..254}; do ping -c 1 $IP & done | \
      grep -oE 'bytes from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/bytes from //'

Die Ausgabe sind alle IP-Adressen im `/24` Subnetz.
Neben der eigenen Adresse sollte auch die des Pi dabei sein.

Insgesamt also:

    SUBNET=`ifconfig enp9s0 | \
      grep -oE 'inet addr:[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/inet addr://'`
    for IP in $SUBNET.{1..254}; do ping -c 1 $IP & done | \
      grep -oE 'bytes from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/bytes from //'

#### Windows: TODO

### Per SSH verbinden

Abschließend verbindet man sich per SSH mit dem Raspberry Pi.

#### Linux/Mac

Wenn die IP-Adresse zum Beispiel `10.42.0.232` ist:

    ssh pi@10.42.0.232

#### Windows: TODO

