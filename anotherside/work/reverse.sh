#!/bin/sh
set -eu

######################################################################
# setting
######################################################################

if [ $# -ne 1 ]; then
  echo "invalid input" 1>&2
  exit 1
fi

INPUT_FILE="$1"

######################################################################
# main routine
######################################################################

gawk -v FS='' -v OFS='' '
{
  for (i = NF; i >= 1; i--) { printf "%s", $i; }
  print "";
}
' "${INPUT_FILE}"
