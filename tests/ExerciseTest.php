<?php
namespace WMT\Tests;

class ExerciseTest extends \PHPUnit_Framework_TestCase
{
    public function testGetStartTimeReturnsATimeObject()
    {
        $exercise = new \WMT\Exercise();
        $result = $exercise->setStartTime('2014-05-25 12:00:00');
        $result = $exercise->getStartTime();

        $this->assertInstanceOf('\DateTime', $result);
    }
}
