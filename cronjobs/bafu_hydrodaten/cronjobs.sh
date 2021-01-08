# */5 * * * *
# /home/opendata/scripts/hydrodata.ch__organize_by_date.sh

# 57 23 * * *
# There's one data file for today that is being updated every 5 minutes or so. Before midnight, move this file to
# the archive. This way, ODS only parses the new file and keeps the unchanched old files untouched in its cache,
# so that updating the dataset fast.
mv /home/opendata/public_html/stata/hydrodata.ch/hydropro/2289/realtime/* /home/opendata/public_html/stata/hydrodata.ch/hydropro/2289/archive/
