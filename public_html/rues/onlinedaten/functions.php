<?php

/*
 * query()
 * PURPOSE: Ermöglicht kürzere SQL-Queries auf DB
 * 
 */
function query ($sql, $id=false, $connection=false, $multiquery=false){
  if (!$connection) {global $cnx; $connection = $cnx;} //default connection/database
  if ($multiquery !== false) {
	//multiquery for INSERT/UPDATE via SQL-File
	//$res = mysqli_multi_query($connection, $sql) or die("<div class='red'><pre>Abfrage fehlgeschlagen: [$sql]<br><br>" . mysqli_error($connection)."</pre></div>"); 
	if (mysqli_multi_query($connection, $sql)) {
		do {
			/*
			if ($result = mysqli_store_result($connection)) {
				while ($row = mysqli_fetch_row($result)) {
					printf("%s\n", $row[0]);
				}
				mysqli_free_result($result);
			}
			*/			
			if (!mysqli_more_results($connection)) {
				break;
			}
			if (!mysqli_next_result($connection)) {
				if (mysqli_error($connection) != '') die("<div class='red'><pre>Abfrage fehlgeschlagen: " . mysqli_error($connection)." <br><br>$sql</pre></div>"); 
				break;
			}
		} while (true);
	}
	return true;
  }
  $res = mysqli_query($connection, $sql); //ignore errors  or die("<div class='red'>Abfrage fehlgeschlagen: [$sql]<br><br>" . mysqli_error($connection)."</div>");
  $i=0;
  if ($res !== true) { //for all return-queries (SELECT etc., not DELETE/INSERT)
	  if (is_int($id)){
		while ($tuple = mysqli_fetch_row($res)) {
		  $data[$i++] = $tuple[0];
		}
	  }else{
		while ($tuple = mysqli_fetch_array($res, MYSQLI_ASSOC)) {
		  if ($id == false) $data = $tuple;
		  elseif ($id === 'auto_incr') $data[$i++] = $tuple;
		  elseif (is_array($id)) {
			$tmp = [];
			foreach ($id as $k => $v) $tmp[] = $tuple[$v];
			$kk = implode('|', $tmp);
			$data[$kk] = $tuple;
		  } else $data[$tuple[$id]] = $tuple;
		}
	  }
  }
  
  if (isset($data)) return $data; else return false;
}


?>