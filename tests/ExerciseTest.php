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

    public function startTimeProvider()
    {
        return array(
            array('2014-05-25 12:00:00', '2014-05-25 12:00:00'),
            array('2013-05-25', '2013-05-25 00:00:00')
        );
    }
}
