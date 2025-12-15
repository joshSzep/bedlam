#!/bin/bash

# Concatenate all manuscript chapters with dividers

OUTPUT=""
DIVIDER=$'\n\n---\n\n'

for i in $(seq -w 1 28); do
    FILE="manuscript/${i}.md"
    if [[ -f "$FILE" ]]; then
        if [[ -n "$OUTPUT" ]]; then
            OUTPUT+="$DIVIDER"
        fi
        OUTPUT+="$(cat "$FILE")"
    fi
done

echo "$OUTPUT"
