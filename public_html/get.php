<?php
// load config file
require_once("../resources/config.php");

// load functions
require_once(LIBRARY_PATH . "/functions.php");

	$conn = openConnection($config);
	
if ($_REQUEST['type'] == "song") {
	$title = $_REQUEST['title'];
	fetchSong($conn, $title);
} elseif ($_REQUEST['type'] == "concert") {
	fetchConcert($conn);
} elseif ($_REQUEST['type'] == "concert_list") {
	$concert_id = $_REQUEST['concert_id'];
	fetchConcertListing($conn,$concert_id);
}
	closeConnection($conn);
?>
