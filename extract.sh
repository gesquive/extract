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
    echo "Need any of following executable(s) to extract: $1" >&2
    exit 1
}

function exe() {
    echo ">>" "$@"
    "$@"
}

###############################################################################

function extract_tbz2() {
    if ! check "tar"; then
        print_missing "tar, lbunzip2"
    fi
    if check "lbunzip2"; then
        exe tar --use-compress-program=lbunzip2 -xvf "$1"
    else
        exe tar xvjf "$1"
    fi
}

function extract_tgz() {
    if ! check "tar"; then
        print_missing "tar, unpigz"
    fi
    if check "unpigz"; then
        exe tar --use-compress-program=unpigz -xvf "$1"
    else
        exe tar xvzf "$1"
    fi
}

function extract_txz() {
    if ! check "tar"; then
        print_missing "tar, pixz"
    fi
    if check "pixz"; then
        exe tar --use-compress-program=pixz -xvf "$1"
    else
        exe tar xvJf "$1"
    fi
}

function extract_bz2() {
    if check "lbunzip2"; then
        exe lbunzip2 -fk "$1"
    elif check "bunzip2"; then
        exe bunzip2 -fk "$1"
    else
        print_missing "lbunzip2, bunzip2"
    fi
}

function extract_exe() {
    if check "cabextract"; then
        exe cabextract "$1"
    else
        print_missing "cabextract"
    fi
}

function extract_gz() {
    if check "unpigz"; then
        exe unpigz -fk "$1"
    elif check "gunzip"; then
        exe gunzip -fk "$1"
    else
        print_missing "unpigz, gunzip"
    fi
}

function extract_lzma() {
    if check "unlzma"; then
        exe unlzma -fk "$1"
    else
        print_missing "unlzma"
    fi
}

function extract_rar() {
    if check "unrar"; then
        exe unrar x -ad "$1"
    else
        print_missing "unrar"
    fi
}

function extract_tar() {
    if check "tar"; then
        exe tar xvf "$1"
    else
        print_missing "tar"
    fi
}

function extract_xz() {
    if check "pixz"; then
        exe pixz -d "$1"
    elif check "unxz"; then
        exe unxz -fk "$1"
    else
        print_missing "pixz, unxz"
    fi
}

function extract_z() {
    if check "uncompress"; then
        exe uncompress -f "$1"
    else
        print_missing "uncompress"
    fi
}

function extract_zip() {
    if check "unzip"; then
        exe unzip "$1"
    else
        print_missing "unzip"
    fi
}

function extract_7z() {
    if check "7z"; then
        exe 7z x "$1"
    else
        print_missing "7z"
    fi
}

###############################################################################

for x in "$@"; do
    if [ -f "$x" ] ; then
        NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
        case "$NAME" in
            *.tar.bz)   extract_tbz2 "$x" ;;
            *.tar.bz2)  extract_tbz2 "$x" ;;
            *.tar.gz)   extract_tgz "$x" ;;
            *.tar.xz)   extract_txz "$x" ;;
            *.bz2)      extract_bz2 "$x" ;;
            *.exe)      extract_exe "$x" ;;
            *.gz)       extract_gz "$x" ;;
            *.lzma)     extract_lzma "$x" ;;
            *.pxz)      extract_xz "$x" ;;
            *.rar)      extract_rar "$x" ;;
            *.tar)      extract_tar "$x" ;;
            *.tbz)      extract_tbz2 "$x" ;;
            *.tbz2)     extract_tbz2 "$x" ;;
            *.tz2)      extract_tbz2 "$x" ;;
            *.tgz)      extract_tgz "$x" ;;
            *.txz)      extract_txz "$x" ;;
            *.xz)       extract_xz "$x" ;;
            *.z)        extract_z "$x" ;;
            *.zip)      extract_zip "$x" ;;
            *.7z)       extract_7z "$x" ;;
            *) echo "extract: '$x' - unknown archive method" ;;
        esac
    else
        echo "'$x' - file does not exist"
		exit 1;
    fi
done

exit 0;
