# Add seconds (":00") to the timestamp of historical data.
# This is necessary for ODS to be able to import the 15 current data (15-minute interval) alongside the corrected historical data.
sed "s/:00/:00:00/g" /home/opendata/public_html/rues/onlinedaten/korrigiert/online-korrigiert.csv > /home/opendata/public_html/rues/onlinedaten/korrigiert/online-korrigiert_sekunden.csv