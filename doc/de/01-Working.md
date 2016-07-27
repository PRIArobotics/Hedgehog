# Arbeiten mit dem Raspberry Pi

Dieses Dokument soll beschreiben, wie man einen vorbereiteten Raspberry Pi in Betrieb nimmt.

Die Stromversorgung eines Hedgehogs erfolgt über den Stromanschluss mit einem LiPo-Akku oder ein Netzteil
(7.4V).

Ein Raspberry Pi ohne Hardware-Platine kann über den MicroUSB-Anschluss mit Strom versorgt werden.

> **Achtung:** Ein Raspberry Pi mit Hardware-Platine kann **nicht** über MicroUSB mit Strom versorgt werden.

Zusätzlich braucht man noch Eingabe- und Ausgabemöglichkeiten;
Benutzername und Passwort lauten (standardmäßig) `pi`/`raspberry`.

## Direkt

Maus, Tastatur (USB) & Bildschirm (HDMI) anstecken, an der grafischen Oberfläche anmelden.

## Über USART

Der USART0 befindet sich neben der Stromversorgung, nach Anschluss an einen geeigneten Adapter kann zum Beispiel über folgende Befehle kommuniziert werden.

Falls der Pi schon länger läuft, wird man keinen Prompt sehen; einmal Enter oder ^C drücken, damit ein neuer ausgegeben wird.

#### Linux/Mac

    #picocom kann mit ^A^Q beendet werden
    picocom -b 115200 /dev/ttyUSB0

    #screen kann mit ^A^D beendet werden
    screen /dev/ttyUSB0 115200

#### Windows: TODO

### Pinbelegung von USB2Serial-Adaptern im Labor: TODO

## Über SSH

Der Raspberry Pi ist konfiguriert, über seinen Ethernet-Port per DHCP eine Adresse zu beziehen, also kann man sich über Ethernet mit dem Pi verbinden und auch Internet für ihn freigeben.
Danach benötigt man noch die IP-Adresse des Pi, und verbindet sich über SSH.

### Ethernet-Freigabe

#### Ubuntu

_Network Connections_ > (geeignete Ethernet-Konfiguration) > _Edit_ > _IPv4 Settings_ > _Method: Shared to other computers_

#### Linux/Mac: TODO

#### Windows: TODO

### WIFI: TODO

### IP-Adresse ermitteln

Wenn man auch anders mit dem Pi verbunden ist, kann man direkt nachschauen:

    ifconfig eth0 | \
      grep -oE 'inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
      sed 's/inet addr://'

Wenn man selbst die Verbindung freigibt (über Ethernet oder WIFI), kann man die Adresse eventuell anders ermitteln, zum Beispiel:

#### Linux/Mac

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

