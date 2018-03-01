<?php

  ini_set('display_errors', 'On');
  error_reporting(E_ALL | E_STRICT);

  // load config file
  require_once("../resources/config.php");

  // load funcitons
  require_once(LIBRARY_PATH . "/functions.php");

  // load header
  require_once(TEMPLATES_PATH . "/header.php");

  $conn = openConnection($config);

?>
<script>
$(document).ready(function() {

	getConcerts();

});
</script>
</head>
<body>

    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
<!--    <a class="navbar-brand" href="#">Nuotisto</a> -->
        <a class="navbar-brand" href="#"><img src="img/kyl-header-logo.png" class="img-responsive img-navbar-brand" alt="KYL logo"></a>
      </div>
      <div class="collapse navbar-collapse" id="myNavbar">
        <ul class="nav navbar-nav">
          <li><a href="index.php">Nuotit</a></li>
          <li class="active"><a href="concerts.php">Keikat</a></li>
          <li><a href="#">Listat</a></li>
        </ul>
      </div>
      </div>
    </nav>
    <div class="container-fluid">
      <br>
        <div class="row">
            <div class="col-lg-3 col-sm-1"></div>
            <div class="col-lg-6 col-sm-10">

                <div id="concerts">

                </div>

            </div>
            <div class="col-lg-3 col-sm-1"></div>
        </div>
    </div>
	
<?php

  // load footer
  require_once(TEMPLATES_PATH . "/footer.php");

  closeConnection($conn);
?>
