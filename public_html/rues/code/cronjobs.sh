# cronjob 1 on cyon.ch:
tail -q -n +2 /home/opendata/public_html/rues/onlinedaten/roh/*_RUES_Online_S3.csv >> /home/opendata/public_html/rues/onlinedaten/roh/2018_bis_aktuell.csv && mv /home/opendata/public_html/rues/onlinedaten/roh/*_RUES_Online_S3.csv /home/opendata/public_html/rues/onlinedaten/roh/archiv/

# cronjob 2 on cyon.ch:
cp /home/opendata/public_html/rues/onlinedaten/korrigiert/online-korrigiert.csv /home/opendata/public_html/rues/onlinedaten/online2002_aktuell.csv && tail -q -n +2 /home/opendata/public_html/rues/onlinedaten/roh/2018_bis_aktuell.csv >> /home/opendata/public_html/rues/onlinedaten/online2002_aktuell.csv

# cronjob 3 on cyon.ch:
curl https://rues.data-bs.ch/onlinedaten/raw2db.php > /dev/null 2>&1

