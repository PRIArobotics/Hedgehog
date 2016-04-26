# Python auf dem Orange Pi

Dieses Dokument soll beschreiben, wie der Orange Pi für das Arbeiten mit Python vorbereitet werden kann.

Python gibt es in den Versionen 2 und 3, die teilweise nicht kompatibel sind.
Es gibt Möglichkeiten, Bibliotheken für Python 2 und 3 zu schreiben, jedoch gibt es auch solche, die nur eine Version unterstützen.
Mit `pip` hat Python ein eigenes Tool zur Paket- und Abhängigkeitsverwaltung.
Wegen der Möglichkeit von Versionskonflikten zwischen den Abhängigkeiten verschiedener Anwendungen wird empfohlen, Anwendungen in eigenen „virtual environments“ zu betreiben.

Auf Details wird in diesem Dokument nicht eingegangen; es wird lediglich gezeigt, wie die notwendigen Werkzeuge installiert werden, und virtual environments zum Arbeiten mit Python 2 und 3 erstellt und benutzt werden.

## Benötigte Software

Python 2 & 3 sind am Orange Pi schon vorinstalliert, `pip` allerdings nicht.
Mit den folgenden Befehlen werden `pip` und `virtualenv` für Python 3 installiert.
Damit können für beide Python-Versionen Environments erstellt werden.

    sudo apt-get -y install python3-pip
    pip3 install virtualenv

Für die Installation mancher Module sind außerdem die Header-Definitionen von Python notwendig.
Diese werden folgendermaßen für beide Versionen installiert:

    sudo apt-get -y install python-dev python3-dev

## Mit virtuellen Environments arbeiten

Sobald eine Anwendung Abhängigkeiten benötigt ist es jedenfalls sinnvoll, in einem eigenen Environment zu arbeiten.
Besonders wenn es sich um Experimente handelt, kann man damit Änderungen isolieren, damit man das Experiment leicht verwerfen oder von Null weg wiederholen kann.

Ein virtuelles Environment für Python 3 wird folgendermaßen angelegt, verwendet, und rückstandslos gelöscht:

    python3 -m virtualenv env
    . env/bin/activate
    # Pakete im Environment installieren
    pip install some_package
    # ...
    deactivate
    rm -rf env

Wobei `env` durch einen beliebigen Ordnernamen ersetzt werden kann; `env` ist jedoch typisch.
Solange ein Environment aktiviert ist, wird dem Prompt der Name vorgestellt, etwa:

    ...
    orangepi@OrangePI:~$ . env/bin/activate
    (env)orangepi@OrangePI:~$ deactivate
    orangepi@OrangePI:~$
    ...

Dasselbe für Python 2:

    python3 -m virtualenv -p python env
    . env/bin/activate
    # Pakete im Environment installieren
    pip install some_package
    # ...
    deactivate
    rm -rf env

## Versionenvergleich

Zum Schluss ein Vergleich der verschiedenen Versionen.
Global sind `python`, `python3`, `pip3` und `virtualenv` installiert.

    which python; python --version
    # /usr/bin/python
    # Python 2.7.9
    which python3; python3 --version
    # /usr/bin/python3
    # Python 3.4.3
    which pip3; pip3 --version
    # /usr/bin/pip3
    # pip 1.5.6 from /usr/lib/python3/dist-packages (python 3.4)
    python3 -m virtualenv --version
    # 13.1.2

In einem Environment für Python 3 zeigen `python` und `pip` auf das Environment, und arbeiten mit Python 3.
Man beachte außerdem, dass die `pip`-Version neuer ist als die, die global installiert ist:
Die Ubuntu-Repositories sind nicht auf dem neuesten Stand.

    python3 -m virtualenv env
    . env/bin/activate
    which python; python --version
    # /home/orangepi/env/bin/python
    # Python 3.4.3
    which pip; pip --version
    # /home/orangepi/env/bin/pip
    # pip 7.1.2 from /home/orangepi/env/lib/python3.4/site-packages (python 3.4)
    deactivate
    rm -rf env

Analoges gilt für ein Environment für Python 2.

    python3 -m virtualenv -p python env
    . env/bin/activate
    which python; python --version
    # /home/orangepi/env/bin/python
    # Python 2.7.9
    which pip; pip --version
    # /home/orangepi/env/bin/pip
    # pip 7.1.2 from /home/orangepi/env/local/lib/python2.7/site-packages (python 2.7)
    deactivate
    rm -rf env

