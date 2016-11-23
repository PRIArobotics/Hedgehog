# Hedgehog Light

Der Hedgehog Light ist ein Roboter-Controller, der für den Einsatz in verschiedenen Anwendungsbereichen entwickelt wurde.
Insbesondere ist Hedgehog Light auf den Bildungsbereich ausgelegt, allerdings wurde darauf geachtet,
ein auch abseits von Klassenzimmern wertvolles Produkt zu erzeugen.
Wichtige Merkmale von Hedgehog Light sind deshalb

- volle Kontrolle über das Gerät
    - alle Möglichkeiten des verbauten Raspberry Pi
    - großteils offene Hardware und Software
    - fortgeschrittene Benutzer_innen sind nicht eingeschränkt
- einfache Verbindung mit Entwicklungsgeräten
    - kabelgebunden über Ethernet
    - drahtlos über WLAN
    - Hedgehog-Entwicklungswerkzeuge (Web IDE) oder SSH
- einheitliches Steuerprotokoll
    - lokale Programme und solche im Netzwerk
    - Protokoll-Stack auf Zuverlässigkeit ausgelegt
    - wenig Einschränkungen für Programmierschnittstellen
- vielseitige Programmierschnittstellen (APIs)
    - visuell und textuell
    - einfach, aber nicht einschränkend
- bastlerfreundlich
    - Kompatibilität mit günstigen Motoren, Servos & Sensoren
    - Anbaumöglichkeiten an Lego-Modelle
- unterrichtsfreundlich
    - mehrere Controller im selben WLAN-Netzwerk vermeiden Funk-Überlastung
    - vielseitige Lehrmöglichkeiten: visuelle & textuelle Programmierung,
      Sensorik & Regelungstechnik, autonomes Fahren, Microcontroller-Programmierung,
      verteilte Anwendungen, ...

## Hardware

Hedgehog besteht aus einem Raspberry Pi 3 (Software-Controller, SWC)
und einer zusätzlichen Platine (Hardware-Controller, HWC) zur Ansteuerung von Peripherie-Komponenten (Motoren etc.).
Das Kernstück des HWC ist ein STM32F4 Microcontroller, der über USART mit dem SWC kommuniziert.
Die Elektronik ist in ein Plexiglas-Gehäuse eingepackt, das auch Beschriftungen für die Anschlüsse eingraviert hat.

Der Controller kann über einen Akku oder eine stationäre Spannungsquelle mit Strom versorgt werden.

## Software

Auf dem HWC läuft eine quelloffene, in C geschriebene Firmware.
Sie empfängt und beantwortet die Befehle des SWC über USART.
Damit können Motoren, Servos, ein Summer, sowie einige LEDs angesteuert werden,
Analog- und Digitalsensoren konfiguriert und ausgelesen werden,
sowie verschiedene serielle Schnittstellen benutzt werden.
Der HWC warnt über den Summer außerdem bei niedriger Akkuspannung.

Auf dem SWC wird Raspbian als Betriebssystem verwendet.
Das Kernstück der SWC-Software ist der in Python geschriebene, quelloffene "Hedgehog Server".
Er kommuniziert über das Hedgehog-Protokoll mit Clients, sowohl lokal als auch über das Netzwerk.
Neben Antworten auf Client-Befehle kann der Hedgehog Server auch selbstständig Nachrichten senden,
wenn bestimmte Ereignisse (etwa ein abgeschlossenes Programm) auftreten.
Wenn notwendig leitet der Hedgehog Server Befehle an den HWC weiter, um diese umzusetzen.

Clients sind generell Programme, die über das Hedgehog-Protokoll mit dem Server kommuniziert.
Üblicherweise wird dazu eine Client-API benutzt, die die Protokolldetails vor dem Benutzer versteckt;
solche APIs können sowohl blockierend als auch nicht-blockierend sein.
Die ursprüngliche Hedgehog Python-API implementiert beispielsweise auf einem nicht-blockierenden Kern,
und darauf aufbauend eine blockierende API; beide Modelle sind für den Benutzer zugänglich.

Weiters wird aktuell eine Web IDE entwickelt.
Damit können Benutzer in ihrem Browser visuell oder textuell Programme schreiben und diese auf dem Controller ausführen.

## Verwendung

* [Vorbereiten eines Raspberry Pi](Setup.md)
* [Inbetriebnahme](Working.md)
* [Python auf dem Raspberry Pi](python.md)
* [HWC-Entwicklung](hwc.md)
* **TODO**

