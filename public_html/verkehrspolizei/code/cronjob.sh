# cronjob to copy radar data from Uni BE server, every day at 04:00 am: 
curl https://radardaten.fdn.iwi.unibe.ch/data/getradar > /home/opendata/public_html/verkehrspolizei/radar.tsv && curl https://radardaten.fdn.iwi.unibe.ch/data/getrecord > /home/opendata/public_html/verkehrspolizei/record.tsv && curl https://username:password@radardaten.fdn.iwi.unibe.ch/data/getmysqldump > /home/opendata/public_html/verkehrspolizei/mysqldump.sql