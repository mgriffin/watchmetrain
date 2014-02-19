<?php
use \Silex\WebTestCase;

class frontendTest extends WebTestCase
{
    public function createApplication()
    {
        $app = require __DIR__.'/../bootstrap.php';
        $app['debug'] = true;
        $app['exception_handler']->disable();

        return $app;
    }

    public function testThereIsAnIndexPage()
    {
        $client = $this->createClient();
        $crawler = $client->request('GET', '/');

        $this->assertTrue($client->getResponse()->isOK());
    }

    public function testThereIsAnAboutPage()
    {
        $client = $this->createClient();
        $crawler = $client->request('GET', '/about');

        $this->assertTrue($client->getResponse()->isOK());
    }
}
