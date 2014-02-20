<?php

class ArticleTest extends PHPUnit_Framework_TestCase
{
    public function testGetlistReturnsFiveArticles()
    {
        $dbResultSet = array(
            array('title' => 'One', 'slug' => 'one'),
            array('title' => 'Two', 'slug' => 'two'),
            array('title' => 'Three', 'slug' => 'three'),
            array('title' => 'Four', 'slug' => 'four'),
            array('title' => 'Five', 'slug' => 'five')
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
