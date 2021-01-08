# */5 * * * *
# /home/opendata/scripts/hydrodata.ch__organize_by_date.sh

# 2 2 * * *
# There's one data file for today that is being updated every 5 minutes or so. Move this file to
# the archive without overwriting. This way, ODS only parses the new file and keeps the unchanged old files
# untouched in its cache, so that updating the dataset fast.
mv -n /home/opendata/public_html/stata/hydrodata.ch/hydropro/2289/realtime/* /home/opendata/public_html/stata/hydrodata.ch/hydropro/2289/archive/ && rm -f /home/opendata/public_html/stata/hydrodata.ch/hydropro/2289/realtime/*
