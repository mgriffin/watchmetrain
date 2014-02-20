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
}
