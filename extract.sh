#!/usr/bin/env bash
#
# Utility script to extract archives
# https://github.com/gesquive/extract

VERSION="v1.1.1"

function usage() {
    echo "Extracts bz2, exe, gz, lzma, rar, tar, tbz2, tgz, xz, z and zip archives"
    echo ""
    echo "Usage:"
    echo "  extract [flags] <archive> [<archive>...]"
    echo ""
    echo "Flags:"
    echo "  -h, --help      Show this help and exit"
    echo "  -v, --version   Show the version and exit"
    exit 1;
}

if [ -z "$1" ]; then
    usage;
fi

if [ "$1" == "-h" ]||[ "$1" == "--help" ]; then
    usage;
elif [ "$1" == "-v" ]||[ "$1" == "--version" ]; then
    echo "extract ${VERSION}"
    exit 1
fi

function check() {
    if ! type "$1" &> /dev/null; then
        return 1;
    fi
    return 0
}

function print() {
    printf "$*\n"
}

function print_err() {
    printf "$*\n" >&2
}

function print_missing() {
    print_err "Need any of following executable(s) to extract: $1"
    exit 1
}

function echo_run() {
    echo ">>" "$@"
    "$@"
}

###############################################################################

function extract_tbz2() {
    if ! check "tar"; then
        print_missing "tar, lbunzip2"
    fi
    if check "lbunzip2"; then
        echo_run tar --use-compress-program=lbunzip2 -xvf "$1"
    else
        echo_run tar xvjf "$1"
    fi
}

function extract_tgz() {
    if ! check "tar"; then
        print_missing "tar, unpigz"
    fi
    if check "unpigz"; then
        echo_run tar --use-compress-program=unpigz -xvf "$1"
    else
        echo_run tar xvzf "$1"
    fi
}

function extract_txz() {
    if ! check "tar"; then
        print_missing "tar, pixz"
    fi
    if check "pixz"; then
        echo_run tar --use-compress-program=pixz -xvf "$1"
    else
        echo_run tar xvJf "$1"
    fi
}

function extract_bz2() {
    if check "lbunzip2"; then
        echo_run lbunzip2 -fk "$1"
    elif check "bunzip2"; then
        echo_run bunzip2 -fk "$1"
    else
        print_missing "lbunzip2, bunzip2"
    fi
}

function extract_exe() {
    if check "cabextract"; then
        echo_run cabextract "$1"
    else
        print_missing "cabextract"
    fi
}

function extract_gz() {
    if check "unpigz"; then
        echo_run unpigz -fk "$1"
    elif check "gunzip"; then
        echo_run gunzip -fk "$1"
    else
        print_missing "unpigz, gunzip"
    fi
}

function extract_rar() {
    if check "unrar"; then
        echo_run unrar x -ad "$1"
    else
        print_missing "unrar"
    fi
}

function extract_tar() {
    if check "tar"; then
        echo_run tar xvf "$1"
    else
        print_missing "tar"
    fi
}

function extract_xz() {
    if check "pixz"; then
        echo_run pixz -d "$1"
    elif check "xz"; then
        echo_run xz -dfk "$1"
    else
        print_missing "pixz, xz"
    fi
}

function extract_z() {
    if check "uncompress"; then
        echo_run uncompress -f "$1"
    else
        print_missing "uncompress"
    fi
}

function extract_zip() {
    if check "unzip"; then
        echo_run unzip "$1"
    else
        print_missing "unzip"
    fi
}

function extract_7z() {
    if check "7z"; then
        echo_run 7z x "$1"
    else
        print_missing "7z"
    fi
}

###############################################################################

for x in "$@"; do
    if [ ! -f "$x" ] ; then
        echo "'$x' - file does not exist"
		exit 1;
    fi
    NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    case "$NAME" in
        *.tar.bz)   extract_tbz2 "$x" ;;
        *.tar.bz2)  extract_tbz2 "$x" ;;
        *.tar.gz)   extract_tgz "$x" ;;
        *.tar.xz)   extract_txz "$x" ;;
        *.bz2)      extract_bz2 "$x" ;;
        *.exe)      extract_exe "$x" ;;
        *.gz)       extract_gz "$x" ;;
        *.lzma)     extract_xz "$x" ;;
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
        *) echo "extract: '$x' - unknown archive" ;;
    esac
done

exit 0;
