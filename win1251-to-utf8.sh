#!/usr/bin/bash

set -euxo pipefail

tmpfile=$(mktemp /tmp/subtitle.XXXXXX)
iconv -f windows-1251 -t utf-8 $1 > $tmpfile
cp $tmpfile $1
