# Below are the cronjobs at cyon.ch to be run at 05:00 every day.

# Backup the current data file with a timestamp in its name so that old values are retained (because the file contaisn a rolling window of values)
# Escape % because crontab ses this as line breaks, see https://stackoverflow.com/a/38487305/5005585
cp /home/opendata/public_html/lufthygiene/regionales-mikroklima/airmet_bs_sensirion_pm25_aktuell.csv /home/opendata/public_html/lufthygiene/regionales-mikroklima/airmet_bs_sensirion_pm25_$(date "+\%Y-\%m-\%dT\%H-\%M-\%S").csv

# Below are the cronjobs at cyon.ch to be run at 5 minutes past the hour every hour.

# Get hourly average data from the database via the web gui (https://luftqualitaet.ch/messdaten/datenarchiv/abfrage): 
# Chrischona for crontab at cyon:
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_chrischona.txt --output /home/opendata/public_html/lufthygiene/roh/Chrischona_Luft_01.01.2000.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
# Feldbergstrasse single commands: 
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_feldbergstrasse_bis_2018.txt --output /home/opendata/public_html/lufthygiene/roh/Feldbergstrasse_Luft_01.01.2000.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_feldbergstrasse_ab_2019.txt  --output /home/opendata/public_html/lufthygiene/roh/Feldbergstrasse_Luft_01.01.2019.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
# Feldbergstrasse on one line for crontab at cyon: 
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_feldbergstrasse_bis_2018.txt --output /home/opendata/public_html/lufthygiene/roh/Feldbergstrasse_Luft_01.01.2000.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage && curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_feldbergstrasse_ab_2019.txt  --output /home/opendata/public_html/lufthygiene/roh/Feldbergstrasse_Luft_01.01.2019.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
# St. Johannplatz single commands: 
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_st_johannplatz_bis_2018.txt --output /home/opendata/public_html/lufthygiene/roh/St_Johannplatz_Luft_01.01.2000.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_st_johannplatz_ab_2019.txt  --output /home/opendata/public_html/lufthygiene/roh/St_Johannplatz_Luft_01.01.2019.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage
# St. Johannplatz on one line for crontab at cyon: 
curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_st_johannplatz_bis_2018.txt --output /home/opendata/public_html/lufthygiene/roh/St_Johannplatz_Luft_01.01.2000.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage && curl -X POST --silent --data @/home/opendata/public_html/lufthygiene/roh/form_st_johannplatz_ab_2019.txt  --output /home/opendata/public_html/lufthygiene/roh/St_Johannplatz_Luft_01.01.2019.csv https://luftqualitaet.ch/messdaten/datenarchiv/abfrage

# Basel-Binningen for crontab at cyon.ch:
curl -X GET --silent --output /home/opendata/public_html/lufthygiene/roh/Basel_Binningen_Luft_01.01.2000.csv -G "https://bafu.meteotest.ch/nabel/index.php/ausgabe/index/german" -d "webgrab=no&schadstoff=1&stationsliste[]=5&station=5&schadstoffsliste[]=1&schadstoffsliste[]=2&schadstoffsliste[]=3&schadstoffsliste[]=6&schadstoffsliste[]=7&schadstoffsliste[]=12&schadstoffsliste[]=8&schadstoffsliste[]=13&schadstoffsliste[]=9&schadstoffsliste[]=10&schadstoffsliste[]=11&datentyp=stunden&zeitraum=frei&von=2018-06-01&bis=2020-12-31&ausgabe=csv&abfrageflag=true&nach=station"


# The following cronjob code is still in use for a certain time (as long as we get the current measure data every 30 minutes via FTP upload) but not really needed anymore. 
# Base folders on live server and c9 instance: 
# /home/opendata/
# /home/ubuntu/workspace/

export basedir="/home/ubuntu/workspace/public_html/lufthygiene/roh"
# Append contents of the partial csv file (except the two header lines and the last line which does not contain measured values) to the complete csv file
tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv | head -q -n -1 >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv 
# Remove 1 header line, sort by YYYY MM DDD HH:MM:SS, remove duplicates, save to tempfile (for details on sorting, see see https://www.unix.com/unix-for-dummies-questions-and-answers/131166-sort-field-date-mm-dd-yyyy.html)
tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv
# Write header and data from temp file to data file
head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv
cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv
# delete temp files
rm $basedir/chrischona_sort_temp.csv
rm $basedir/airmet_bs_chrischona_header.csv

# everything on one line for c9.io
# export basedir="/home/ubuntu/workspace/public_html/lufthygiene/roh" && tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv | head -q -n -1 >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv && head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv && cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && rm $basedir/chrischona_sort_temp.csv && rm $basedir/airmet_bs_chrischona_header.csv
# everything on one line for cyon
# export basedir="/home/opendata/public_html/lufthygiene/roh" && tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv | head -q -n -1 >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv && head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv && cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && rm $basedir/chrischona_sort_temp.csv && rm $basedir/airmet_bs_chrischona_header.csv