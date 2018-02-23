<?php

// load config file
require_once("../resources/config.php");

// load functions
require_once(LIBRARY_PATH . "/functions.php");

function raw_json_encode($input, $flags = 0) {
    $fails = implode('|', array_filter(array(
        '\\\\',
        $flags & JSON_HEX_TAG ? 'u003[CE]' : '',
        $flags & JSON_HEX_AMP ? 'u0026' : '',
        $flags & JSON_HEX_APOS ? 'u0027' : '',
        $flags & JSON_HEX_QUOT ? 'u0022' : '',
    )));
    $pattern = "/\\\\(?:(?:$fails)(*SKIP)(*FAIL)|u([0-9a-fA-F]{4}))/";
    $callback = function ($m) {
        return html_entity_decode("&#x$m[1];", ENT_QUOTES, 'UTF-8');
    };
    return preg_replace_callback($pattern, $callback, json_encode($input, $flags));
}


function fetchSong2($conn, $name) {
    $json = array();

    $sql = "SELECT kml_arrangement.id as arr_id , kml_song.name as name FROM kml_song INNER JOIN kml_arrangement ON kml_song.id = kml_arrangement.song_id WHERE name LIKE '%" . $name .  "%' ORDER BY name";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {

		// output data of each row
        while ($row = $result->fetch_assoc()) {
        
			$json_song = array();


			$bus = array(
              'arr_id' => $row["arr_id"],
              'name' => $row["name"]
            );
            array_push($json_song, $bus);
	
			// We'll use this arr_id to look for all the other required data
			$arr_id = $row["arr_id"];
			
			// Second, we'll find person authors
		    $sql = "SELECT kml_person.id as person_id , name , contribution_type , author_order FROM (SELECT * FROM kml_arrangement_author WHERE arrangement_id = " . $arr_id . ") AS arrauth INNER JOIN kml_person ON arrauth.person_id = kml_person.id";
			$result2 = $conn->query($sql);
			
			if ($result2->num_rows > 0) {

				// go through persons
				while ($row2 = $result2->fetch_assoc()) {
					
					$bus = array(
					  'person_id' => $row2["person_id"],
					  'name' => $row2["name"],
					  'contribution_type' => $row2["contribution_type"],
					  'author_order' => $row2["author_order"]
					);
					array_push($json_song, $bus);
				}
			}
			
			$result2->free();
			
			// Third, we'll find alias authors
		    $sql = "SELECT kml_alias.person_id as person_id , kml_alias.id as alias_id , alias as name , contribution_type , author_order FROM (SELECT * FROM kml_arrangement_author WHERE arrangement_id = " . $arr_id . ") AS arrauth INNER JOIN kml_alias ON arrauth.alias_id = kml_alias.id";
			$result2 = $conn->query($sql);

			if ($result2->num_rows > 0) {

				// go through persons
				while ($row2 = $result2->fetch_assoc()) {
				
					$bus = array(
					  'person_id' => $row2["person_id"],
					  'alias_id' => $row2["alias_id"],
					  'name' => $row2["name"],
					  'contribution_type' => $row2["contribution_type"],
					  'author_order' => $row2["author_order"]
					);
					array_push($json_song, $bus);
				}
			}

			##$result2->free();
			
			// Last, we'll find any files attached to the arrangement
		    $sql = "SELECT A.id as file_id, B.file_extension, A.version , A.description FROM (SELECT * FROM kml_file WHERE arrangement_id =" . $arr_id . ") AS A INNER JOIN kml_filetype AS B ON A.filetype_id = B.id";
			$result2 = $conn->query($sql);

			if ($result2->num_rows > 0) {

				// go through persons
				while ($row2 = $result2->fetch_assoc()) {
				
					$bus = array(
					  'file_id' => $row2["file_id"],
					  'file_extension' => $row2["file_extension"],
					  'version' => $row2["version"],
					  'description' => $row2["description"]
					);
					array_push($json_song, $bus);
				}
			}

			##$result2->free();
			
			/// and now push all the records of one song/arrangement to the json array
			array_push($json,$json_song);
		}
    } else {
        echo '0 results';
    }
    $result -> free();

    echo raw_json_encode($json);
}

$title = $_REQUEST['title'];

$conn = openConnection($config);

$conn->query("SET NAMES UTF8");

## mysqli_set_charset('utf8', $conn);

## header('Content-type: text/html; charset=utf-8');

fetchSong2($conn, $title);

closeConnection($conn);

?>
