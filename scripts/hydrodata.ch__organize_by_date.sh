#!/bin/bash
# currently not used - we switched to one file per day instead of one file per 10 minutes to circumvent
# the 10K files per folder limit of the cyon.ch ftp server

DIR=/home/opendata/public_html/stata/hydrodata.ch/hydropro/2289
target=$DIR
cd "$DIR" || exit

for file in *; do
    if [ -f "$file" ]; then
      # year=$(date -r "$file" "+%Y")
      year=${file:19:4}
      #subfolderName=$(date -r "$file" "+%Y-%m-%d")
      subfolderName=${file:19:10}
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
