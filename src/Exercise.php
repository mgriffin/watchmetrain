<?php
namespace WMT;

class Exercise
{
    protected $start_time;
    protected $duration;
    protected $distance;
    protected $comment;
    protected $deleted;

    public function setStartTime($time)
    {
        $this->start_time = new \DateTime(gmdate('Y-m-d H:i:s', strtotime($time)));
    }

    public function getStartTime()
    {
        return $this->start_time->format('Y-m-d H:i:s');
    }

    public function setDistance($distance)
    {
        preg_match('/(?P<number>[\d\.]+)(?P<unit>km|m?)/', $distance, $match);

        if($match['unit'] === 'km') {
            $match['number'] = $match['number'] * 1000;
        }

        $this->distance = $match['number'];
    }

    public function getDistance()
    {
        return $this->distance;
    }
}
