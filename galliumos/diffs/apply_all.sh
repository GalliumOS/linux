#!/bin/sh
#

BASENAME=$(basename $0)
INTERACTIVE=
#DOIF=":"
seq_file="galliumos/diffs/sequence"
seq_dir=$(dirname "$seq_file")

[ "$1" = "-i" ] && INTERACTIVE=1

if [ ! -f "$seq_file" ]; then
  echo "$BASENAME: fatal: $seq_file not found. make sure cwd is repo root!"
  exit 1
fi

for diff in $(cat "$seq_file" | grep -v "^#" ); do
  if [ "$INTERACTIVE" ]; then
    resp="incoherent"
    while [ "$resp" = "incoherent" ]; do
      echo "$BASENAME: apply $diff [Ynq]: \c"
      read resp
      case "$resp" in
        [Yy]*|'') $DOIF patch -p1 < "$seq_dir/$diff" ;;
        [Nn]*)    ;;
        [Qq]*)    exit 0 ;;
        *) resp="incoherent" ;;
      esac
    done
  else
    echo
    echo "$BASENAME: applying $diff"
    $DOIF patch -p1 < "$seq_dir/$diff"
  fi
done

