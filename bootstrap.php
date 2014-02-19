<?php
require 'vendor/autoload.php';

$app = new \Silex\Application();

$app->get('/', function() {
    return "narf";
});

return $app;
