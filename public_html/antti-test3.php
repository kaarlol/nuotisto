<?php

// load config file
require_once("../resources/config.php");

// load functions
require_once(LIBRARY_PATH . "/functions.php");

$title = $_REQUEST['title'];

$conn = openConnection($config);

$conn->query("SET NAMES UTF8");


$query="
SELECT name, arrangement_id 
FROM 
(SELECT arrangement_id FROM (SELECT id FROM kml_person WHERE name LIKE ?) AS a INNER JOIN kml_arrangement_author AS b ON a.id = b.person_id
 UNION
 SELECT arrangement_id FROM (SELECT id FROM kml_alias WHERE alias LIKE ?) AS a INNER JOIN kml_arrangement_author AS b ON a.id = b.alias_id
 UNION
 SELECT a.id as arrangement_id FROM kml_arrangement AS a INNER JOIN (SELECT id FROM kml_song WHERE name LIKE ?) as b ON a.song_id = b.id 
) AS a 
INNER JOIN (SELECT a.id, b.name FROM kml_arrangement AS a INNER JOIN kml_song AS b ON a.song_id = b.id) as b
ON a.arrangement_id = b.id
";


$editedString = "%" . mb_ereg_replace(" ","%",$title) . "%";

$sql_stmt = $conn->stmt_init();
if(! $sql_stmt->prepare($query))
{
	echo "Failed to prepare statement<br />";
}
else {
	$sql_stmt->bind_param("sss",$editedString,$editedString,$editedString);
	$sql_stmt->execute();
	$result = get_result($sql_stmt);
	
	var_dump($result);
}

closeConnection($conn);

?>
