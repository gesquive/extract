#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

if [ -x "$(command -v git)" ] && [ -d ".git" ]; then
    # Add version info to the script if git information is present
    VERSION="$(git describe --always --tags)"
    GIT_DIRTY="$(test -n "`git status --porcelain`" && echo "+CHANGES" || true)"
    sed -i "s/^VERSION=.*/VERSION=\"${VERSION}${GIT_DIRTY}\"/" extract.sh
fi

install -d /usr/local/bin/
install -m 755 ./extract.sh /usr/local/bin/extract
