#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "Script must be run as root!"
	exit 1
fi

LC="$1"

if [ "x" = "x$LC" ]; then
    LC="$LC_NAME"
fi

if [ "x" = "x$LC" ]; then
	echo "LC_NAME is not set; please provide a locale name argument!"
	exit 1
fi

sum="`md5sum /etc/locale.gen`"
sed -i -re 's/^# *('$LC'.*)$/\1/' /etc/locale.gen
if [ "$sum" = "`md5sum /etc/locale.gen`" ]; then
    echo "no changes were made! $LC is not a valid locale or already enabled"
else
    locale-gen
fi

