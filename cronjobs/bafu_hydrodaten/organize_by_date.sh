#!/bin/bash

DIR=/home/opendata/public_html/stata/hydrodata.ch/hydropro/2289
target=$DIR
cd "$DIR"

for file in *; do
    # Top tear folder name
    # year=$(stat -f "%Sm" -t "%Y" $file)
    year=$(date -r $file "+%Y")
    # Secondary folder name
    # subfolderName=$(stat -f "%Sm" -t "%d-%m-%Y" $file)
    subfolderName=$(date -r $file "+%Y-%m-%d")
    if [ ! -d "$target/$year" ]; then
        mkdir "$target/$year"
        echo "starting new year: $year"
    fi
    if [ ! -d "$target/$year/$subfolderName" ]; then
        mkdir "$target/$year/$subfolderName"
        echo "starting new day & month folder: $subfolderName"
    fi
    echo "moving file $file"
    mv "$file" "$target/$year/$subfolderName"

done
