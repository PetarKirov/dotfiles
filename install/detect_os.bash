#!/bin/bash

set -euo pipefail

if ! [ -z "${OS:-}" ] && ! [ -z "${DIST:-}" ]; then
    echo "Variables \$OS=$OS and \$DIST=$DIST already set." \
        'Skipping OS detection.'
    return 0
fi

OS=''
DIST=''
SUDO=''

case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
        OS='linux'
        if [ "$EUID" -ne 0 ]; then
            SUDO='sudo'
        fi
        if [ -f /etc/os-release ]; then
            # freedesktop.org and systemd
            . /etc/os-release
            DIST="$NAME"
        elif type lsb_release >/dev/null 2>&1; then
            # linuxbase.org
            DIST="$(lsb_release -si)"
        elif [ -f /etc/lsb-release ]; then
            # For some versions of Debian/Ubuntu without lsb_release command
            . /etc/lsb-release
            DIST="$DISTRIB_ID"
        elif [ -f /etc/debian_version ]; then
            # Older Debian/Ubuntu/etc.
            DIST='Debian'
        else
            # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
            OS="$(uname -s)"
        fi
    ;;
    darwin*)
        OS='osx'
        SUDO='sudo'
    ;;
    msys*)
        OS='windows'
        DIST='msys'
    ;;
    *)
        OS=notset
    ;;
esac

OS=$(echo $OS | tr '[:upper:]' '[:lower:]' | awk '{print $1;}')
DIST=$(echo $DIST | tr '[:upper:]' '[:lower:]' | awk '{print $1;}')
