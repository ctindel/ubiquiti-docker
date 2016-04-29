#!/bin/bash

# The unifi debian package depends on mongodb-server but the 
#  official mongodb 3.2 files are called mongodb-org-server
#  so we need to modify the deb dependencies 

if [[ -z "$1" ]]; then
  echo "Syntax: $0 debfile"
  exit 1
fi

DEBFILE="$1"
TMPDIR=`mktemp -d /tmp/deb.XXXXXXXXXX` || exit 1
OUTPUT=`basename "$DEBFILE" .deb`.modified.deb

if [[ -e "$OUTPUT" ]]; then
  echo "$OUTPUT exists."
  rm -r "$TMPDIR"
  exit 1
fi

dpkg-deb -x "$DEBFILE" "$TMPDIR"
dpkg-deb --control "$DEBFILE" "$TMPDIR"/DEBIAN

if [[ ! -e "$TMPDIR"/DEBIAN/control ]]; then
  echo DEBIAN/control not found.

  rm -r "$TMPDIR"
  exit 1
fi

CONTROL="$TMPDIR"/DEBIAN/control

MOD=`stat -c "%y" "$CONTROL"`
sed -e 's/mongodb-server/mongodb-org-server/g' $CONTROL > $CONTROL.new && \
    mv $CONTROL.new $CONTROL

if [[ "$MOD" == `stat -c "%y" "$CONTROL"` ]]; then
  echo Not modified.
else
  echo Building new deb...
  dpkg -b "$TMPDIR" "$OUTPUT"
fi

rm -rf "$TMPDIR"
