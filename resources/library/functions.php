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

function fetchSong($conn, $name)
{
    $sql = "SELECT * FROM kml_song WHERE name LIKE '%" . $name .  "%' ORDER BY name";
    $result = $conn->query($sql);


    if ($result->num_rows > 0) {
        // output data of each row
        $n = 1;
        while ($row = $result->fetch_assoc()) {
            echo '<div class="panel panel-default">
                  <a data-toggle="collapse" data-parent="#accordion" href="#collapse-'. $row["id"] .'">
                    <div class="panel-heading text-left">
                      <h4 class="panel-title">

                        ' . $row["name"]  .'

                        </h4>
                    </div>
                  </a>
                  <div id="collapse-'. $row["id"] .'" class="panel-collapse collapse">
                    <div class="panel-body text-left">
                      Test
                    </div>
                  </div>
                </div>
                ';
            $n++;
        }
    } else {
        echo '0 results';
    }
}

function fetchConcerts($conn)
{
    $sql = "SELECT title, venue, DATE_FORMAT(start, '%e.%c. klo %H:%i') start, DATE_FORMAT(end, '%H:%i') end FROM concerts";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // output data of each row
        $n = 1;
        while ($row = $result->fetch_assoc()) {
            echo '
            <div class="jumbotron">
              <h2>' . $row["title"] . '</h2>
              <p>
              Paikka: ' . $row["venue"] . '<br />
              ' . $row["start"] . ' - ' . $row["end"] . '
              </p>
            </div>

            ';
        }
    }
}

function closeConnection($conn)
{
    $conn->close();
}
