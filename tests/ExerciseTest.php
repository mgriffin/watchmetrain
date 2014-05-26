<?php
namespace WMT\Tests;

class ExerciseTest extends \PHPUnit_Framework_TestCase
{
    protected $exercise;

    public function setUp()
    {
        $this->exercise = new \WMT\Exercise();
    }

    /**
     * @dataProvider startTimeProvider
     */
    public function testSetStartTimeCanParseEnglishStrings($time, $expected)
    {
        $this->exercise->setStartTime($time);
        $result = $this->exercise->getStartTime();

        $this->assertEquals($expected, $result);
    }

    /**
     * @dataProvider distanceProvider
     */
    public function testDistance($distance, $expected)
    {
        $this->exercise->setDistance($distance);
        $result = $this->exercise->getDistance();

        $this->assertEquals($expected, $result);
    }

    /**
     * @dataProvider durationProvider
     */
    public function testDuration($duration, $expected)
    {
        $this->exercise->setDuration($duration);
        $result = $this->exercise->getDuration();

        $this->assertEquals($expected, $result);
    }

    public function testIsDeleted()
    {
        $this->assertFalse($this->exercise->isDeleted());

        $this->exercise->delete();
        $this->assertTrue($this->exercise->isDeleted());
    }

    /**
     * @dataProvider commentProvider
     */
    public function testComment($comment, $expected)
    {
        $this->exercise->setComment($comment);
        $result = $this->exercise->getComment();

        $this->assertEquals($expected, $result);
    }

    public function startTimeProvider()
    {
        return array(
            array('2014-05-25 12:00:00', '2014-05-25 12:00:00'),
            array('2013-05-25', '2013-05-25 00:00:00'),
            array('May 5th 2014 12pm', '2014-05-05 12:00:00')
        );
    }

    public function distanceProvider()
    {
        return array(
            array('10000', '10000'),
            array('10000m', '10000'),
            array('10km', '10000'),
            array('5400', '5400'),
            array('5400m', '5400'),
            array('5.4km', '5400')
        );
    }

    public function durationProvider()
    {
        return array(
            array('1h 4m 35s', 3875),
            array('4m 35s', 275),
            array('35s', 35)
        );
    }

    public function commentProvider()
    {
        return array(
            array('', '')
        );
    }
}
