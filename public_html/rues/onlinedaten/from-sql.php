<?php
/**
 * This file loads content from four different data tables depending on the required time range.
 * The stockquotes table containts 1.7 million data points. Since we are loading OHLC data and
 * MySQL has no concept of first and last in a data group, we have extracted groups by hours, days
 * and months into separate tables. If we were to load a line series with average data, we wouldn't
 * have to do this.
 * 
 * @param callback {String} The name of the JSONP callback to pad the JSON within
 * @param start {Integer} The starting point in JS time
 * @param end {Integer} The ending point in JS time
 *
 * HISTORY:
 *   Original: https://github.com/highcharts/highcharts/blob/master/samples/data/from-sql.php
 *   Original Example:  https://jsfiddle.net/gh/get/library/pure/highcharts/highcharts/tree/master/samples/stock/demo/lazy-loading/
 *   07.06.2018, JB/BL: Adapted for StatA BS OGD Project RUES
 */

// Suppress error output to browser to prevent breaking JSONP format
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

// Start output buffering to catch any unexpected output
ob_start();

// Try to include database connection, but handle errors gracefully
try {
	@include 'dbconnect.php'; //# MySQL Database connection handling, returns $cnx
	@include 'functions.php'; //# diverse PHP functions, e.g. query()
} catch (Exception $e) {
	// Error will be handled below
}

// Clear any output that might have been generated (errors, warnings, etc.)
ob_clean();

// Check if database connection is available
if (!isset($cnx) || !$cnx || mysqli_connect_errno()) {
	$callback = isset($_GET['callback']) ? $_GET['callback'] : 'callback';
	if (preg_match('/^[a-zA-Z0-9_]+$/', $callback)) {
		header('Content-Type: text/javascript');
		echo $callback . '([]);';
	} else {
		header('Content-Type: text/javascript');
		echo 'callback([]);';
	}
	exit;
}

// get the parameters
$callback = isset($_GET['callback']) ? $_GET['callback'] : '';
if (!$callback || !preg_match('/^[a-zA-Z0-9_]+$/', $callback)) {
	header('Content-Type: text/javascript');
	echo $callback ? $callback . '([]);' : '[];';
	exit;
}

$start = @$_GET['start'];
if ($start && !preg_match('/^[0-9]+$/', $start)) {
	header('Content-Type: text/javascript');
	echo $callback . '([]);';
	exit;
}
if (!$start) $start = mktime(0,0,0,1,1,2002) * 1000;

$end = @$_GET['end'];
if ($end && !preg_match('/^[0-9]+$/', $end)) {
	header('Content-Type: text/javascript');
	echo $callback . '([]);';
	exit;
}
if (!$end) $end = time() * 1000;


// set UTC time
$dum = query("SET time_zone = '+00:00'", false);

// set some utility variables
$range = $end - $start;
$startTime = gmstrftime('%Y-%m-%d %H:%M:%S', $start / 1000);
$endTime = gmstrftime('%Y-%m-%d %H:%M:%S', $end / 1000);


// find the right table
// one month range loads raw data (15min/1h)
if ($range < 31 * 24 * 3600 * 1000) {
	$table = 'data_raw';

// five year range loads daily data
} elseif ($range < 5 * 12 * 31 * 24 * 3600 * 1000) {
	$table = 'data_agg_d';

// greater range loads monthly data
} else {
	$table = 'data_agg_m';
} 


// get data from mySQL-DB
$sql = "
	SELECT 
		round(unix_timestamp(`Startzeitpunkt`) * 1000) as `Startzeitpunkt`,
		`RUS.W.O.S3.LF` as `LF`, 
		`RUS.W.O.S3.O2` as `O2`, 
		`RUS.W.O.S3.PH` as `PH`, 
		`RUS.W.O.S3.TE` as `TE`
	from $table 
	where `Startzeitpunkt` between '$startTime' and '$endTime'
	order by Startzeitpunkt
";

$result = mysqli_query($cnx, $sql);
if (!$result) {
	// On error, return empty array in JSONP format
	header('Content-Type: text/javascript');
	echo $callback . '([]);';
	exit;
}

$rows = array();
while ($row = mysqli_fetch_assoc($result)) {
	extract($row);
	$rows[] = "[$Startzeitpunkt, $LF, $O2, $PH, $TE]";
}

// print it
header('Content-Type: text/javascript');
echo "/* console.log(' start = $start, end = $end, startTime = $startTime, endTime = $endTime '); */\n";
echo $callback ."([\n" . join(",\n", $rows) ."\n]);";

// End output buffering
ob_end_flush();

?>