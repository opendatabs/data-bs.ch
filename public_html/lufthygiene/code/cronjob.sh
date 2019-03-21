#This is the cronjob at cyon.ch to be run at least every 15 minutes. 
#Base folders on live server and c9 instance: 
#/home/opendata/
#/home/ubuntu/workspace/

export basedir="/home/ubuntu/workspace/public_html/lufthygiene/roh"
#Append contents of the partial csv file (except the two header lines) to the complete csv file
tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv 
#Remove 1 header line, sort by YYYY MM DDD HH:MM:SS, remove duplicates, save to tempfile (for details on sorting, see see https://www.unix.com/unix-for-dummies-questions-and-answers/131166-sort-field-date-mm-dd-yyyy.html)
tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv
#Write header and data from temp file to data file
head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv
cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv
#delete temp files
rm $basedir/chrischona_sort_temp.csv
rm $basedir/airmet_bs_chrischona_header.csv

#everything on one line for c9.io
#export basedir="/home/ubuntu/workspace/public_html/lufthygiene/roh" && tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv && head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv && cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && rm $basedir/chrischona_sort_temp.csv && rm $basedir/airmet_bs_chrischona_header.csv
#everything on one line for cyon
#export basedir="/home/opendata/public_html/lufthygiene/roh" && tail -q -n+3 $basedir/airmet_bs_chrischona_roh.csv >> $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && tail -q -n+2 $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o $basedir/chrischona_sort_temp.csv && head -n1  $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv >  $basedir/airmet_bs_chrischona_header.csv && cat $basedir/airmet_bs_chrischona_header.csv $basedir/chrischona_sort_temp.csv > $basedir/airmet_bs_chrischona_2010_bis_aktuell.csv && rm $basedir/chrischona_sort_temp.csv && rm $basedir/airmet_bs_chrischona_header.csv