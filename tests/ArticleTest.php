<?php

class ArticleTest extends PHPUnit_Framework_TestCase
{
    public function testGetlistReturnsFiveArticles()
    {
        $articles = new \WMT\ArticleMapper();
        $result = $articles->getList();

        $this->assertEquals(5, sizeof($result));
    }
}
