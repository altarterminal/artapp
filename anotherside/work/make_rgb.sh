#!/bin/sh
set -eu

######################################################################
# setting
######################################################################

if [ $# -ne 1 ];
  echo "invalid input" 1>&2
  exit 1
fi

INPUT_FILE="$1"

prefix='out'
out_r="${prefix}_red.txt"
out_g="${prefix}_green.txt"
out_b="${prefix}_blue.txt"

######################################################################
# main routine
######################################################################

cat "${INPUT_FILE}" | tr '■' 'Ｒ' | cat >"${out_r}"
cat "${INPUT_FILE}" | tr '■' 'Ｇ' | cat >"${out_g}"
cat "${INPUT_FILE}" | tr '■' 'Ｂ' | cat >"${out_b}"
