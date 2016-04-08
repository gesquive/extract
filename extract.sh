#!/bin/bash

function usage() {
    echo "Usage: extract <archive>"
    echo "Extracts zip, rar, bz2, gz, tar, tbz2, tgz, z, 7z, and ex archives"
    exit 1;
}

if [ -z "$1" ]; then
    usage;
fi

if [ "$1" == "-h" ]; then
    usage;
fi


for x in "$@"; do
    if [ -f "$x" ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$x"    ;;
          *.tar.gz)    tar xvzf ./"$x"    ;;
          *.tar.xz)    tar xvJf ./"$x"    ;;
          *.lzma)      unlzma ./"$x"      ;;
          *.bz2)       bunzip2 ./"$x"     ;;
          *.rar)       unrar x -ad ./"$x" ;;
          *.gz)        gunzip ./"$x"      ;;
          *.tar)       tar xvf ./"$x"     ;;
          *.tbz2)      tar xvjf ./"$x"    ;;
          *.tgz)       tar xvzf ./"$x"    ;;
          *.zip)       unzip ./"$x"       ;;
          *.Z)         uncompress ./"$x"  ;;
          *.7z)        7z x ./"$x"        ;;
          *.xz)        unxz ./"$x"        ;;
          *.exe)       cabextract ./"$x"  ;;
          *)           echo "extract: '$x' - unknown archive method" ;;
        esac
    else
        echo "'$x' - file does not exist"
		exit 1;
    fi
done

exit 0;
