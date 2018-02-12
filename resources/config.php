<?php

/*
    The important thing to realize is that the config file should be included in every
    page of your project, or at least any page you want access to these settings.
    This allows you to confidently use these settings throughout a project because
    if something changes such as your database credentials, or a path to a specific resource,
    you'll only need to update it here.
*/

//$url = getenv('JAWSDB_URL');

$url = 'mysql://ywgkma3pud2pg3qr:yqak86ne4luvia81@cig4l2op6r0fxymw.cbetxkdyhwsb.us-east-1.rds.amazonaws.com:3306/qtulhtq93pxmb744';
$dbparts = parse_url($url);

$config = array(
    "db" => array(
          "dbname" => ltrim($dbparts['path'],'/'),
          "username" => $dbparts['user'],
          "password" => $dbparts['pass'],
          "host" => $dbparts['host']
    ),
    "urls" => array(
        "baseUrl" => "localhost:8888"
    ),
    "paths" => array(
        "resources" => "/resources",
        "images" => array(
            "content" => $_SERVER["DOCUMENT_ROOT"] . "/images/content",
            "layout" => $_SERVER["DOCUMENT_ROOT"] . "/images/layout"
        )
    )
);

/*
    I will usually place the following in a bootstrap file or some type of environment
    setup file (code that is run at the start of every page request), but they work
    just as well in your config file if it's in php (some alternatives to php are xml or ini files).
*/

/*
    Creating constants for heavily used paths makes things a lot easier.
    ex. require_once(LIBRARY_PATH . "Paginator.php")
*/
defined("LIBRARY_PATH")
    or define("LIBRARY_PATH", realpath(dirname(__FILE__) . '/library'));

defined("TEMPLATES_PATH")
    or define("TEMPLATES_PATH", realpath(dirname(__FILE__) . '/templates'));

/*
    Error reporting.
*/
ini_set("error_reporting", "true");
error_reporting(E_ALL|E_STRCT);

?>
