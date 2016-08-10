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
        return 1;
    fi
    return 0
}

function print_missing {
    echo "Cannot find executable(s): $1" >&2
    exit 1
}

function exe() {
    echo ">>" "$@"
    "$@"
}

#unpigz < /path/to/archive.tar.gz | (cd /where/to/unpack/it/ && tar xvf -)

for x in "$@"; do
    if [ -f "$x" ] ; then
        NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
        case "$NAME" in
            *.tar.bz2 )
                if ! check "tar"; then
                    print_missing "tar"
                fi
                if check "lbunzip2"; then
                    exe tar --use-compress-program=lbunzip2 -xvf "$x"
                else
                    exe tar xvjf "$x"
                fi
            ;;
            *.tar.gz )
                if ! check "tar"; then
                    print_missing "tar"
                fi
                if check "unpigz"; then
                    exe tar --use-compress-program=unpigz -xvf "$x"
                else
                    exe tar xvzf "$x"
                fi
            ;;
            *.tar.xz )
                if ! check "tar"; then
                    print_missing "tar"
                fi
                if check "pixz"; then
                    exe tar --use-compress-program=pixz -xvf "$x"
                else
                    exe tar xvJf "$x"
                fi
            ;;
            *.bz2 )
                if check "lbunzip2"; then
                    exe lbunzip2 -fk "$x"
                elif check "bunzip2"; then
                    exe bunzip2 -fk "$x"
                else
                    print_missing "lbunzip2, bunzip2"
                fi
            ;;
            *.exe )
                if check "cabextract"; then
                    exe cabextract "$x"
                else
                    print_missing "cabextract"
                fi
            ;;
            *.gz )
                if check "unpigz"; then
                    exe unpigz -fk "$x"
                elif check "gunzip"; then
                    exe gunzip -fk "$x"
                else
                    print_missing "unpigz, gunzip"
                fi
            ;;
            *.lzma )
                if check "unlzma"; then
                    exe unlzma -fk "$x"
                else
                    print_missing "unlzma"
                fi
            ;;
            *.rar )
                if check "unrar"; then
                    exe unrar x -ad "$x"
                else
                    print_missing "unrar"
                fi
            ;;
            *.tar )
                if check "tar"; then
                    exe tar xvf "$x"
                else
                    print_missing "tar"
                fi
            ;;
            *.tbz2)      check "tar" && tar xvjf ./"$x"           ;;
            *.tgz)       check "tar" && tar xvzf ./"$x"           ;;
            *.xz )
                if check "pixz"; then
                    exe pixz -d "$x"
                elif check "unxz"; then
                    exe unxz -fk "$x"
                else
                    print_missing "pixz, unxz"
                fi
            ;;
            *.z)
                if check "uncompress"; then
                    exe uncompress -f "$x"
                else
                    print_missing "uncompress"
                fi
            ;;
            *.zip)
                if check "unzip"; then
                    exe unzip "$x"
                else
                    print_missing "unzip"
                fi
            ;;
            *.7z )
                if check "7z"; then
                    exe 7z x "$x"
                else
                    print_missing "7z"
                fi
            ;;
            *) echo "extract: '$x' - unknown archive method" ;;
        esac
    else
        echo "'$x' - file does not exist"
		exit 1;
    fi
done

exit 0;
