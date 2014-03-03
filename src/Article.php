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

    public function getTitle()
    {
        return $this->title;
    }

    public function setSlug($slug = null)
    {
        if ($slug === null) {
        }
        return $this->slug = $slug;
    }

    public function getSlug()
    {
        return $this->slug;
    }

    public function setBody($body)
    {
        return $this->body = $body;
    }

    public function getBody()
    {
        return $this->body;
    }

    public function setDate($date)
    {
        return $this->date = $date;
    }

    public function getDate()
    {
        return $this->date;
    }
}
