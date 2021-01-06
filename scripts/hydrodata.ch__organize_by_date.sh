#!/bin/bash

# /home/opendata/scripts/hydrodata.ch__organize_by_date.sh

DIR=/home/opendata/public_html/stata/hydrodata.ch/hydropro/2289
target=$DIR
cd "$DIR" || exit

for file in *; do
    if [ -f "$file" ]; then
      year=$(date -r "$file" "+%Y")
      subfolderName=$(date -r "$file" "+%Y-%m-%d")
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
    fi
done

