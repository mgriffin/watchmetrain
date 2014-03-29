<?php
if (!defined('APP_ROOT')) {
    define('APP_ROOT', __DIR__ . '/');
}
require APP_ROOT . 'vendor/autoload.php';

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

// Set up the database connection
if (file_exists(APP_ROOT . 'database.php')) {
    require APP_ROOT . 'database.php';
} else {
    throw new RuntimeException("There is no database configuration");
}

$app->get('/', function (Application $app) {
    $mapper = new \WMT\ArticleMapper($app['db']);
    $articles = $mapper->getList();
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

$app->get('/blog', function (Application $app) {
    $mapper = new \WMT\ArticleMapper($app['db']);
    $articles = $mapper->getList();
    return $app['twig']->render(
        'blog.html',
        array(
            'articles' => $articles
        )
    );
});

$app->get('/blog/{slug}', function (Application $app, $slug) {
    $mapper = new \WMT\ArticleMapper($app['db']);
    $article = $mapper->getArticle($slug);
    return $app['twig']->render(
        'blog_post.html',
        array(
            'article' => $article
        )
    );
});

return $app;
