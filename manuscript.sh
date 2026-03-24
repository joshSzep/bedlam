#!/bin/bash

# Concatenate all manuscript chapters into a compiled manuscript.

OUTPUT_FILE="MANUSCRIPT.md"

OUTPUT="# Bedlam

A Novel by Joshua Szepietowski"

for i in $(seq -w 1 28); do
    FILE="manuscript/${i}.md"
    if [[ -f "$FILE" ]]; then
        CHAPTER_CONTENT="$(tail -n +2 "$FILE")"
        if [[ -n "$CHAPTER_CONTENT" ]]; then
            CHAPTER_CONTENT="${CHAPTER_CONTENT#$'\n'}"
        fi

        OUTPUT+=$'\n\n'
        OUTPUT+="## $(head -n 1 "$FILE" | sed 's/^# //')"
        OUTPUT+=$'\n\n'
        OUTPUT+="$CHAPTER_CONTENT"
    fi
done

printf '%s\n' "$OUTPUT" > "$OUTPUT_FILE"
