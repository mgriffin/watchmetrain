<?php
namespace WMT\Tests;

class ExerciseTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @dataProvider startTimeProvider
     */
    public function testSetStartTimeCanParseEnglishStrings($time, $expected)
    {
        $exercise = new \WMT\Exercise();
        $exercise->setStartTime($time);
        $result = $exercise->getStartTime();

        $this->assertEquals($expected, $result);
    }

    /**
     * @dataProvider distanceProvider
     */
    public function testDistance($distance, $expected)
    {
        $exercise = new \WMT\Exercise();
        $exercise->setDistance($distance);
        $result = $exercise->getDistance();

        $this->assertEquals($expected, $result);
    }

    /**
     * @dataProvider durationProvider
     */
    public function testDuration($duration, $expected)
    {
        $exercise = new \WMT\Exercise();
        $exercise->setDuration($duration);
        $result = $exercise->getDuration();

        $this->assertEquals($expected, $result);
    }

    public function testIsDeleted()
    {
        $exercise = new \WMT\Exercise();
        $this->assertFalse($exercise->isDeleted());

        $exercise->delete();
        $this->assertTrue($exercise->isDeleted());
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
}
