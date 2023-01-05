# Process data for ODS dataset 100046 "Rheinmesswerte kontinuierlich" and https://rues.data-bs.ch/onlinedaten/onlinedaten.html
# */5 * * * *
curl https://rues.data-bs.ch/onlinedaten/raw2db.php > /dev/null 2>&1

