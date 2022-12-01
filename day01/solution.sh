#!/usr/bin/env bash

SUMS=()
CURRENT=0
PRINT_N=1

if [[ "$part" == "part2" ]]; then
  PRINT_N=3
fi

while read -r line; do
  if [[ "$line" != "" ]]; then
    CURRENT=$((line + CURRENT))
  else
    SUMS+=($CURRENT)
    CURRENT=0
  fi
done <input.txt
SUMS+=($CURRENT)

SORTED_SUMS=$(printf "%s\n" "${SUMS[@]}" | sort -nr | head -n $PRINT_N)
TOTAL=0

while read -r line; do
  TOTAL=$((TOTAL + line))
done <<< "$SORTED_SUMS"

echo $TOTAL
