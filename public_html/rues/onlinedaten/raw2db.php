<?php
/**
 * Import RUES data from CSV to MySQL Database and aggregate it.
 *
 * 1 step: Loads CSV data from files in $dir into MySQL Database. Works with single-line data files as well as with multi-line files. Ignores 1 header line.
 * 2 step: Aggregates DB-tables (through SQL query): raw data to daily and monthly data
 * 
 * When data is imported manually (bulk import into !empty! table), run this SQL query first (Adapt Date Format to MySQL):
 *     UPDATE `data_raw` SET `Startzeitpunkt` = STR_TO_DATE(`Startzeitpunkt`,'%d.%m.%Y %H:%i'), `Endezeitpunkt` = STR_TO_DATE(`Endezeitpunkt`,'%d.%m.%Y %H:%i');
 * 
 * HISTORY:
 *   07.06.2018, BL: Written for StatA BS OGD Project RUES
 *   05.01.2023, JB: Change folder name from archiv to archiv_ods
 */
 
error_reporting(E_ALL);
include 'dbconnect.php';
include 'functions.php';

//# Base directory
$dir = "/home/opendata/public_html/rues/onlinedaten";

//# Get all CSV-Filenames from specific folder
$files = array_diff(scandir($dir."/roh/archiv_ods/"), array('..', '.'));
$anz_files = count($files);

//# log
echo "Einzulesende CSV-Files im Ordner " . $dir."/roh/archiv_ods/: $anz_files <br><br>" ;

if ($anz_files > 0) {
	
	echo "Ausgeführte SQL-Befehle:<br>*********************************<br>";
	
	//# read content of all CSV Files and INSERT content into MySQL-Database
	foreach ($files as $id => $f) {
		$fh = fopen($dir."/roh/archiv_ods/".$f, "r");
		$i=0;

		//# read file content by line
		while(!feof($fh)) {
			
			$l = fgets($fh);
			
			//# skip first header line and empty lines
			if ($i > 0 and $l != "") {
				
				$p = explode(";", $l);
				
				//# convert date format from 01.02.2018 00:00 to 2018-02-01 00:00 (MySQL Date Format)
				$s = "STR_TO_DATE('{$p[0]}','%d.%m.%Y %H:%i')";
				$e = "STR_TO_DATE('{$p[1]}','%d.%m.%Y %H:%i')";
				
				//# Concat dates and values
				$p = array_slice($p, 2);
				$sql_l = "$s, $e, " . implode(",", $p);
				
				//# log
				echo $i.": ".$sql_l ."<br>";
				
				//# run SQL query, insert data into DB (errors will be ignored, e.g. existing Startzeitpunkt).
				$sql = query("INSERT INTO `data_raw`(`Startzeitpunkt`, `Endezeitpunkt`, `RUS.W.O.S3.LF`, `RUS.W.O.S3.O2`, `RUS.W.O.S3.PH`, `RUS.W.O.S3.TE`) VALUES ($sql_l)");
				
			}
			$i++;
		}
		fclose($fh);

		//# move from folder archive_ods to archive_sql
		rename($dir."/roh/archiv_ods/".$f, $dir."/roh/archiv_sql/".$f);

	}



	//# Update other DB tables: 
	//# aggregate data_raw to daily (data_agg_d) and monthly (data_agg_m) data
	$tr = query("
	TRUNCATE data_agg_d;
	INSERT INTO data_agg_d
	  SELECT 
		MIN(Startzeitpunkt),
		MAX(Endezeitpunkt),
		ROUND(AVG(`RUS.W.O.S3.LF`), 2),
		ROUND(AVG(`RUS.W.O.S3.O2`), 2),
		ROUND(AVG(`RUS.W.O.S3.PH`), 2),
		ROUND(AVG(`RUS.W.O.S3.TE`), 2)
	 FROM `data_raw` 
	 GROUP BY DATE_FORMAT(Startzeitpunkt, '%Y-%m-%d') 
	 ORDER BY DATE_FORMAT(Startzeitpunkt,'%Y-%m-%d') ASC;
	 
	TRUNCATE data_agg_m;
	INSERT INTO data_agg_m
	  SELECT 
		MIN(Startzeitpunkt),
		MAX(Endezeitpunkt),
		ROUND(AVG(`RUS.W.O.S3.LF`), 2),
		ROUND(AVG(`RUS.W.O.S3.O2`), 2),
		ROUND(AVG(`RUS.W.O.S3.PH`), 2),
		ROUND(AVG(`RUS.W.O.S3.TE`), 2)
	 FROM `data_raw` 
	 GROUP BY DATE_FORMAT(Startzeitpunkt, '%Y-%m') 
	 ORDER BY DATE_FORMAT(Startzeitpunkt,'%Y-%m') ASC;
	 ",  $id=false, $connection=false,  $multiquery = true) ;

} else {
	echo "Keine neuen CSV-Datenfiles, nichts importiert<br>";
}



?>