#This is the cronjob at cyon.ch to be run at least every 15 minutes. 
#Base folders on live server and c9 instance: 
#/home/opendata/public_html
#/home/ubuntu/workspace

#Append contents of each partial csv file (except the header lines) to the complete csv file, then archive the partial files
tail -q -n+3 /home/ubuntu/workspace/public_html/lufthygiene/roh/airmet_bs_chrischona_roh.csv >> /home/ubuntu/workspace/public_html/lufthygiene/roh/airmet_bs_chrischona_2000_bis_aktuell.csv 

#Remove header, sort by YYYY MM DDD HH:MM:SS, remove duplicates, save to tempfile (for details on sorting, see see https://www.unix.com/unix-for-dummies-questions-and-answers/131166-sort-field-date-mm-dd-yyyy.html)
tail -q -n+2 /home/ubuntu/workspace/public_html/lufthygiene/roh/airmet_bs_chrischona_2000_bis_aktuell.csv | sort -u -t";" -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -k1.12,1.19 -o /home/ubuntu/workspace/public_html/lufthygiene/roh/chrischona_sort_temp.csv
#Write header and data from temp file to data file
cat /home/ubuntu/workspace/public_html/lufthygiene/roh/airmet_chrischona_header.csv /home/ubuntu/workspace/public_html/lufthygiene/roh/chrischona_sort_temp.csv > /home/ubuntu/workspace/public_html/lufthygiene/roh/airmet_bs_chrischona_2000_bis_aktuell.csv
