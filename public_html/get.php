<?php

// load config file
require_once("../resources/config.php");

// load funcitons
require_once(LIBRARY_PATH . "/functions.php");

$title = $_REQUEST['title'];

$conn = openConnection($config);

fetchCollection($conn, $title);

closeConnection($conn);

?>
