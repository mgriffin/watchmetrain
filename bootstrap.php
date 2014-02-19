<?php
require 'vendor/autoload.php';

use \Silex\Application;

$app = new Application();

// Use Twig for templating
$app->register(
    new Silex\Provider\TwigServiceProvider(),
    array(
        'twig.path' => __DIR__.'/templates',
        'debug' => true
    )
);

$app->get('/', function (Application $app) {
    $articles = array();
    return $app['twig']->render(
        'index.html',
        array('articles' => $articles)
    );
});

$app->get('/about', function (Application $app) {
    return $app['twig']->render(
        'about.html'
    );
});

$app->get('/convert', function (Application $app) {
    return $app['twig']->render(
        'convert.html'
    );
});

$app->get('/archive', function (Application $app) {
    return $app['twig']->render(
        'archive.html'
    );
});

return $app;
