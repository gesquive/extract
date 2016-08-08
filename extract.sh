#!/bin/bash
#
# Utility script to extract archives
# https://github.com/gesquive/extract


function usage() {
    echo "Usage: extract <archive> [<archive>...]"
    echo "Extracts bz2, exe, gz, lzma, rar, tar, tbz2, tgz, xz, z and zip archives"
    exit 1;
}

if [ -z "$1" ]; then
    usage;
fi

if [ "$1" == "-h" ]; then
    usage;
fi

function check {
    if [ ! -x "$(command -v $1)" ]; then
        echo "Cannot find required executable: \"$1\"" >&2
        return 1;
    fi
    return 0
}


for x in "$@"; do
    if [ -f "$x" ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   check "tar" && tar xvjf ./"$x"           ;;
          *.tar.gz)    check "tar" && tar xvzf ./"$x"           ;;
          *.tar.xz)    check "tar" && tar xvJf ./"$x"           ;;
          *.lzma)      check "unlzma" && unlzma ./"$x"          ;;
          *.bz2)       check "bunzip2" && bunzip2 ./"$x"        ;;
          *.rar)       check "unrar" && unrar x -ad ./"$x"      ;;
          *.gz)        check "gunzip" && gunzip ./"$x"          ;;
          *.tar)       check "tar" && tar xvf ./"$x"            ;;
          *.tbz2)      check "tar" && tar xvjf ./"$x"           ;;
          *.tgz)       check "tar" && tar xvzf ./"$x"           ;;
          *.zip)       check "unzip" && unzip ./"$x"            ;;
          *.Z)         check "uncompress" && uncompress ./"$x"  ;;
          *.7z)        check "7z" && 7z x ./"$x"                ;;
          *.xz)        check "unxz" && unxz ./"$x"              ;;
          *.exe)       check "cabextract" && cabextract ./"$x"  ;;
          *)           echo "extract: '$x' - unknown archive method" ;;
        esac
    else
        echo "'$x' - file does not exist"
		exit 1;
    fi
done

exit 0;
