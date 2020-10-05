# Process data for ODS dataset 100046 "Rheinmesswerte kontinuierlich" and https://rues.data-bs.ch/onlinedaten/onlinedaten.html
# */5 * * * *
mv /home/opendata/public_html/rues/onlinedaten/*_RUES_Online_S3.csv /home/opendata/public_html/rues/onlinedaten/roh/ && tail -q -n +2 /home/opendata/public_html/rues/onlinedaten/roh/*_RUES_Online_S3.csv >> /home/opendata/public_html/rues/onlinedaten/roh/2020_bis_aktuell.csv && mv /home/opendata/public_html/rues/onlinedaten/roh/*_RUES_Online_S3.csv /home/opendata/public_html/rues/onlinedaten/roh/archiv/
cp /home/opendata/public_html/rues/onlinedaten/korrigiert/online-korrigiert.csv /home/opendata/public_html/rues/onlinedaten/online2002_aktuell.csv && tail -q -n +2 /home/opendata/public_html/rues/onlinedaten/roh/2020_bis_aktuell.csv >> /home/opendata/public_html/rues/onlinedaten/online2002_aktuell.csv
curl https://rues.data-bs.ch/onlinedaten/raw2db.php > /dev/null 2>&1

