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
}
