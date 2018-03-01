<?php

// load config file
require_once("../resources/config.php");

// load functions
require_once(LIBRARY_PATH . "/functions.php");

if ($_REQUEST['type'] == "song") {
	
	$title = $_REQUEST['title'];

	$conn = openConnection($config);

	$conn->query("SET NAMES UTF8");

	## mysqli_set_charset('utf8', $conn);

	## header('Content-type: text/html; charset=utf-8');

	fetchSong($conn, $title);

	closeConnection($conn);

} elseif ($_REQUEST['type'] == "concert") {
	
	$conn = openConnection($config);

	$conn->query("SET NAMES UTF8");
	
	fetchConcert($conn);

	closeConnection($conn);
}

?>
