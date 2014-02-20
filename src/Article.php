<?php
namespace WMT;

class Article
{
    protected $title;
    protected $slug;
    protected $body;
    protected $date;

    public function setTitle($title)
    {
        return $this->title = $title;
    }

    public function setSlug($slug = null)
    {
        if ($slug === null) {
        }
        return $this->slug = $slug;
    }

    public function setDate($date)
    {
        return $this->date = $date;
    }
}
