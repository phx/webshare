#!/bin/bash

URL='https://yourshareurl.com'
WEBROOT='/mnt/media/shared'
FILEHOST='user@host'

while [[ $# -gt 0 ]] && [[ "$1" == "-"* ]]; do
  opt="$1";
  shift;
  case "$opt" in
    "-" ) break 2;;
    "-dir" )
    DIR="$1"; shift;;
  esac
done

FILE=( $@ )
files="$(for i in "${FILE[@]}"; do echo "$i"; done)"
dirs="$(echo "$files" | awk 'BEGIN{FS=OFS="/"}{NF--; print}' | sort -u)"

clipboard() { pbcopy; }

sanitized_filename() {
  if [[ $1 = "-m" ]]; then
    echo "$i" | tr -d "\n" | tr -d "\r" | tr -d '\' | tr "\t" "_" | tr " " "_"
  else
    echo "$FILE" | tr -d "\n" | tr -d "\r" | tr -d '\' | tr "\t" "_" | tr " " "_"
  fi
}

echo
if [[ -z "$FILE" ]]; then
  echo 'must specify at least 1 argument.'
  exit
elif [[ -z "$DIR" ]]; then
  # NO DIRECTORY SPECIFIED
  for i in $dirs; do
    ssh "$FILEHOST" "mkdir -p ${WEBROOT}/${i}"
  done
  for i in "${FILE[@]}"; do
    scp "${i}" "${FILEHOST}:${WEBROOT}/$(sanitized_filename -m)"
  done
  echo
  echo "COPIED TO CLIPBOARD:"
  for i in "${FILE[@]}"; do
    echo "${URL}/$(sanitized_filename -m)"
  done
  for i in "${FILE[@]}"; do
    echo "${URL}/$(sanitized_filename -m)"
  done | clipboard
else
  # DIRECTORY SPECIFIED AS $2
  ssh "$FILEHOST" "mkdir -p ${WEBROOT}/${DIR}"
  for i in $dirs; do
    ssh "$FILEHOST" "mkdir -p ${WEBROOT}/${DIR}/${i}"
  done
  for i in "${FILE[@]}"; do
    scp "${i}" "${FILEHOST}:${WEBROOT}/${DIR}/$(sanitized_filename -m)"
  done
  echo
  echo "COPIED TO CLIPBOARD:"
  for i in "${FILE[@]}"; do
    echo "${URL}/${DIR}/$(sanitized_filename -m)"
  done
  for i in "${FILE[@]}"; do
    echo "${URL}/${DIR}/$(sanitized_filename -m)"
  done | clipboard
fi
echo
