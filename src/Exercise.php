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
        $this->start_time = $time;
    }

    public function getStartTime()
    {
        return new \DateTime($this->start_time);
    }
}
