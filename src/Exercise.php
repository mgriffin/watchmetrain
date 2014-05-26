<?php
namespace WMT;

class Exercise
{
    protected $start_time;
    protected $duration;
    protected $distance;
    protected $comment;
    protected $deleted;

    public function __construct()
    {
        $this->deleted = false;
    }

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

    public function setDuration($duration)
    {
        preg_match('/((?P<hours>\d+)h )?((?P<minutes>\d+)m )?((?P<seconds>\d+)s)/', $duration, $match);
        $hours = isset($match['hours']) ? $match['hours'] : 0;
        $minutes = isset($match['minutes']) ? $match['minutes'] : 0;
        $seconds = isset($match['seconds']) ? $match['seconds'] : 0;

        $this->duration = $seconds + ($minutes * 60) + ($hours * 60 * 60);
    }

    public function getDuration()
    {
        return $this->duration;
    }

    public function isDeleted()
    {
        return $this->deleted;
    }

    public function delete()
    {
        $this->deleted = true;
    }

    public function setComment($comment)
    {
        $this->comment = $comment;
    }

    public function getComment()
    {
        return $this->comment;
    }
}
