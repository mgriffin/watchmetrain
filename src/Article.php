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
}
