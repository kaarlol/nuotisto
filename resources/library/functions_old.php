<?php

function openConnection($config)
{
    $servername = $config['db']['host'];
    $username = $config['db']['username'];
    $password = $config['db']['password'];
    $dbname = $config['db']['dbname'];

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}

function raw_json_encode($input, $flags = 0)
{
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

// PHP version in Nebula 5.3.3 has no MySQLnd library -> hence deal we have to create a get_results() functions by hand...
function get_result( $Statement ) {
    $RESULT = array();
    $Statement->store_result();
    for ( $i = 0; $i < $Statement->num_rows; $i++ ) {
        $Metadata = $Statement->result_metadata();
        $PARAMS = array();
        while ( $Field = $Metadata->fetch_field() ) {
            $PARAMS[] = &$RESULT[ $i ][ $Field->name ];
        }
        call_user_func_array( array( $Statement, 'bind_result' ), $PARAMS );
        $Statement->fetch();
    }
    return $RESULT;
}


/// fetchSong versio 4 -- adds authors years to the person records
function fetchSong($conn, $name) {
    $json = array();
		
	$query="SELECT kml_arrangement.id as arr_id , kml_song.name as name FROM kml_song INNER JOIN kml_arrangement ON kml_song.id = kml_arrangement.song_id WHERE name LIKE CONCAT('%',?,'%') ORDER BY name";
	$sql_stmt = $conn->stmt_init();
	if(! $sql_stmt->prepare($query))
	{
		echo "Failed to prepare statement<br />";
	}
	else {
		$songtitle = $name;
		if (is_null($name)) $songtitle = "";
		$sql_stmt->bind_param("s",$songtitle);
		$sql_stmt->execute();
		$result = get_result($sql_stmt);

		while ($row = array_shift($result)) {
			$json_song = array();
			
			$bus = array(
              'arr_id' 	=> (string) $row["arr_id"],
              'name' 	=> (string) $row["name"]
            );
            array_push($json_song, $bus);

			
			// We'll use this arr_id to look for all the other required data
			$arr_id = $row["arr_id"];
			
		
			// Second, we'll find person authors 
			// N.B. THESE FOLLOW-UP QUERIES NEED NOT BE PREPARED STATEMENTS AS NO (DIRECT) WEB USER INPUT IS POSSIBLE HERE
			
		    $sql = "SELECT kml_person.id as person_id , name , contribution_type , author_order,birth_date,death_date FROM (SELECT * FROM kml_arrangement_author WHERE arrangement_id = " . $arr_id . ") AS arrauth INNER JOIN kml_person ON arrauth.person_id = kml_person.id";
			$result2 = $conn->query($sql);
			
			if ($result2->num_rows > 0) {

				// go through persons
				while ($row2 = $result2->fetch_assoc()) {
					
					$bus = array(
					  'person_id' => $row2["person_id"],
					  'name' => $row2["name"],
					  'contribution_type' => $row2["contribution_type"],
					  'author_order' => $row2["author_order"],
					  'birth_date' => $row2["birth_date"],
					  'death_date' => $row2["death_date"]					  
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
	}
    echo raw_json_encode($json);
}




function closeConnection($conn)
{
    $conn->close();
}