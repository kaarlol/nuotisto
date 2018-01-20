file_msczfile_sib<?php


function openConnection($config) {
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

function fetchCollection($conn, $title) {

  $sql = "SELECT * FROM collection WHERE title LIKE '%" . $title .  "%' OR composer_last_name LIKE '%" . $title .  "%'";
  $result = $conn->query($sql);


  if ($result->num_rows > 0) {
      // output data of each row
      $n = 1;
      while($row = $result->fetch_assoc()) {
          echo '<div class="panel panel-default">
                  <div class="panel-heading text-left">
                    <h4 class="panel-title">
                      <a data-toggle="collapse" data-parent="#accordion" href="#collapse-'. $n .'">
                      ' . $row["title"] . ' - '. $row["composer_first_name"] .' '. $row["composer_last_name"] .'
                      </a>
                      </h4>
                  </div>
                  <div id="collapse-'. $n .'" class="panel-collapse collapse">
                    <div class="panel-body text-left">';
                      if ( $row["file_pdf"] != "" ) {
                        echo '<a href="'. $row['file_pdf'] .'" target="_blank">Lataa PDF</a>';
                      }
                      if ( $row["sib_file"] != "" ) {
                        echo '<a href="'. $row['sib_file'] .'" target="_blank">Lataa Avid Scorch</a>';
                      }
                      if ( $row["file_mscz"] != "" ) {
                        echo '<a href="'. $row['file_mscz'] .'" target="_blank">Lataa MuseScore</a>';
                      }
                      echo
                    '</div>
                  </div>
                </div>
                ';
          $n++;
      }
  } else {
      echo "0 results";
  }

}

function closeConnection($conn) {
  $conn->close();
}

?>
