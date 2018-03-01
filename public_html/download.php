<?php

	// load config file
	require_once("../resources/config.php");

	// load functions
	require_once(LIBRARY_PATH . "/functions.php");

	$file_id = $_REQUEST['id'];

	$conn = openConnection($config);

	downloadFile($conn,$file_id);

	closeConnection($conn);

?>
