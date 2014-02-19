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

        $title = $crawler->filterXpath('//head/title')->text();

        $this->assertTrue($client->getResponse()->isOK());
        $this->assertEquals('index - watchmetrain', $title);
    }

    public function testThereIsAnAboutPage()
    {
        $client = $this->createClient();
        $crawler = $client->request('GET', '/about');

        $title = $crawler->filterXpath('//head/title')->text();

        $this->assertTrue($client->getResponse()->isOK());
        $this->assertEquals('about - watchmetrain', $title);
    }

    public function testThereIsAConvertPage()
    {
        $client = $this->createClient();
        $crawler = $client->request('GET', '/convert');

        $title = $crawler->filterXpath('//head/title')->text();

        $this->assertTrue($client->getResponse()->isOK());
        $this->assertEquals('convert - watchmetrain', $title);
    }

    public function testThereIsAnArchivePage()
    {
        $client = $this->createClient();
        $crawler = $client->request('GET', '/archive');

        $title = $crawler->filterXpath('//head/title')->text();

        $this->assertTrue($client->getResponse()->isOK());
        $this->assertEquals('archive - watchmetrain', $title);
    }
}
