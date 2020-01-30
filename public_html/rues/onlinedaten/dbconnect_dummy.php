<?php
  //  Variablen für MySQL-Zugang und Datenbank
  //  ########################################################################
  //  ACHTUNG: including this file BEFORE session_start()/setcookie() is called leads to 
  //  a header-output-error! Reason: When a file is included, parsing drops out 
  //  of PHP mode and into HTML mode at the beginning of the target file, and 
  //  resumes again at the end.
  //  See: http://ch2.php.net/manual/en/function.include.php
  //  
  //  --> In "/inc/session_check.php", this file can't be included. 
  //      Therefor the vars are written down there separately and have to be 
  //      altered separately if this file is beeing altered!
  //  
  //  ########################################################################
  
  $host       = "localhost";
  $user       = "";
  $pw         = "";
  $dbname_work     = "opendata_rues";
     
  $cnx = mysqli_connect($host, $user, $pw, $dbname_work) or die("Verbindungsaufnahme mit Datenbank-Server fehlgeschlagen");
  
  //Specify UTF-8 as the default character set to use when exchanging data with the MySQL database 
  $cnx->set_charset("utf8");

?>

