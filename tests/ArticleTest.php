<?php

class ArticleTest extends PHPUnit_Framework_TestCase
{
    public function testGetlistReturnsFiveArticles()
    {
        $dbResultSet = array(
            array('title' => 'One', 'slug' => 'one', 'publish_date' => '2014-02-20 12:00:00'),
            array('title' => 'Two', 'slug' => 'two', 'publish_date' => '2014-02-19 12:00:00'),
            array('title' => 'Three', 'slug' => 'three', 'publish_date' => '2014-01-30 12:00:00'),
            array('title' => 'Four', 'slug' => 'four', 'publish_date' => '2014-01-05 12:00:00'),
            array('title' => 'Five', 'slug' => 'five', 'publish_date' => '2014-01-01 12:00:00')
        );

        $mock = $this->getMockBuilder('stdClass')
            ->setMethods(array('execute', 'fetchAll'))
            ->getMock();
        $mock->expects($this->once())
            ->method('execute')
            ->will($this->returnValue(true));
        $mock->expects($this->once())
            ->method('fetchAll')
            ->will($this->returnValue($dbResultSet));

        $conn = $this->getMockBuilder('stdClass')
            ->setMethods(array('prepare'))
            ->getMock();
        $conn->expects($this->once())
            ->method('prepare')
            ->will($this->returnValue($mock));

        $articles = new \WMT\ArticleMapper($conn);
        $result = $articles->getList();

        $this->assertEquals(5, sizeof($result));
        foreach ($result as $r) {
            $this->assertInstanceof('\WMT\Article', $r);
        }
    }

    public function testGetarticleReturnsAnArticle()
    {
        $dbResultSet = array(
            'title' => 'This is a title',
            'slug' => 'this-is-a-title',
            'publish_date' => '2014-03-03 12:00:00',
            'body' => 'Here is the body'
        );

        $mock = $this->getMockBuilder('stdClass')
            ->setMethods(array('execute', 'fetch'))
            ->getMock();
        $mock->expects($this->once())
            ->method('execute')
            ->will($this->returnValue(true));
        $mock->expects($this->once())
            ->method('fetch')
            ->will($this->returnValue($dbResultSet));

        $conn = $this->getMockBuilder('stdClass')
            ->setMethods(array('prepare'))
            ->getMock();
        $conn->expects($this->once())
            ->method('prepare')
            ->will($this->returnValue($mock));

        $mapper = new \WMT\ArticleMapper($conn);
        $result = $mapper->getArticle('this-is-a-title');

        $this->assertEquals('This is a title', $result->getTitle());
        $this->assertEquals('this-is-a-title', $result->getSlug())r
        $this->assertEquals('2014-03-03 12:00:00', $result->getDate());
        $this->assertEquals('Here is the body', $result->getBody());
    }

    public function slugCreationProvider()
    {
        return array(
            array('A fabulous title', 'a-fabulous-title'),
            array('this Title is a bIT MORE...CHALLENging', 'this-title-is-a-bit-more-challenging'),
            array('Noël Séd 45-6523---3242sdafsd˙ó˙é˝ƒ', 'noel-sed-45-6523-3242sdafsd-o-e-f'),
            array('', '')
        );
    }

    /**
     * @dataProvider slugCreationProvider
     */
    public function testSetslugCreatesASlug($title, $slug)
    {
        $article = new \WMT\Article();
        $article->setTitle($title);
        $article->setSlug();

        $result = $article->getSlug();

        $this->assertEquals($slug, $result);
    }
}
