#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

install -d /usr/local/bin/
install -m 755 ./extract.sh /usr/local/bin/extract
