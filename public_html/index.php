<?php

  ini_set('display_errors', 'On');
  error_reporting(E_ALL | E_STRICT);

  // load config file
  require_once("../resources/config.php");

  // load funcitons
  require_once(LIBRARY_PATH . "/functions.php");

  // load header
  require_once(TEMPLATES_PATH . "/header.php");

?>
<script>
$(document).ready(function() {
	$('#search-btn').click(function() {
		submitSearch();
		$('#search-text').val('');
	});
	$('#search-text').on('keyup', function(e) {
		if (e.which === 13) {
			submitSearch();
			$('#search-text').val('');
		} else if (e.which === 27) {
			$('#search-text').val('');
		} else if (this.value.length >= 3) {
			submitSearch();
		}
	});
	$('#search-text').focus().select();
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
        <a class="navbar-brand" href="#"><img src="img/kyl-header-logo.png" class="img-responsive img-navbar-brand" alt="KYL logo"></a>
      </div>
      <div class="collapse navbar-collapse" id="myNavbar">
        <ul class="nav navbar-nav">
          <li class="active"><a href="index.php">Nuotit</a></li>
          <li><a href="concerts.php">Keikat</a></li>
        </ul>
      </div>
      </div>
    </nav>
    <div class="container-fluid">
      <br>
        <div class="row">
            <div class="col-lg-3 col-sm-1"></div>
            <div class="col-lg-6 col-sm-10">

                <div class="input-group">
                  <input type="text" class="form-control" placeholder="Hae kappaletta tai tekijää" id="search-text">
                  <div class="input-group-btn">
                    <button class="btn btn-default" id="search-btn">
                      <i class="glyphicon glyphicon-search"></i>
                    </button>
                  </div>
                </div>

            </div>
            <div class="col-lg-3 col-sm-1"></div>
        </div>
        <br>
        <div class="row">
            <div class="col-lg-3 col-sm-1"></div>
            <div class="col-lg-6 col-sm-10">
              <div class="panel-group" id="accordion">

              </div>
            </div>
            <div class="col-lg-3 col-sm-1"></div>
        </div>
    </div>

<?php
  // load footer
  require_once(TEMPLATES_PATH . "/footer.php");
?>
