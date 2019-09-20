#!/usr/bin/env bash
# install extract
set -e

DL_URL="https://raw.githubusercontent.com/gesquive/extract/master/extract.sh"
OUTPATH="/usr/local/bin/extract"


if [ "$1" == "local" ]; then # local install
    cp extract.sh "${OUTPATH}"
else # internet install
    curl -sfL ${DL_URL} -o "${OUTPATH}"
fi

chmod +x "${OUTPATH}"