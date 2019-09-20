#!/usr/bin/env bash
# install extract
set -e

DL_URL="https://raw.githubusercontent.com/gesquive/extract/master/extract.sh"
OUTPATH="/usr/local/bin/extract"

curl -o ${OUTPATH} -sfL ${DL_URL}
chmod +x ${OUTPATH}
