#!/bin/bash

ARCHIVE_PATH="$1"
EXTRACT_DIR="$2"

if [ -z "$ARCHIVE_PATH" ] || [ -z "$EXTRACT_DIR" ]; then
    echo "Usage: $0 <ARCHIVE_PATH> <EXTRACT_DIR>"
    exit 1
fi

if [ ! -f "$ARCHIVE_PATH" ]; then
    echo "Archive not found: $ARCHIVE_PATH"
    exit 1
fi

mkdir -p "$EXTRACT_DIR"

if [[ "$ARCHIVE_PATH" == *.zip ]]; then
    unzip -o "$ARCHIVE_PATH" -d "$EXTRACT_DIR"
elif [[ "$ARCHIVE_PATH" == *.tar.gz ]]; then
    tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"
else
    echo "Unsupported archive format: $ARCHIVE_PATH"
    exit 1
fi
