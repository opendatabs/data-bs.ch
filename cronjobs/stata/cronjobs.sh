# Backup the current data files with a timestamp in its name so that old values are retained (because the file contains a rolling window of values)
# Escape % because crontab sees this as line breaks, see https://stackoverflow.com/a/38487305/5005585
# 20 0 * * *
cp /home/opendata/public_html/stata/md/covid19_cases/covid_hosp.csv /home/opendata/public_html/stata/md/covid19_cases/covid_hosp_$(date "+\%Y-\%m-\%dT\%H-\%M-\%S").csv
