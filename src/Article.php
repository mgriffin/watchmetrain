<?php
namespace WMT;

use \Netcarver\Textile\Parser as Textile;

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
            // replace non letter or digit by -
            $slug = preg_replace('~[^\\pL\d]+~u', '-', $this->title);
            $slug = trim($slug, '-');
            if (function_exists('iconv')) {
                $slug = iconv('utf-8', 'us-ascii//TRANSLIT', $slug);
            }
            $slug = strtolower($slug);
            $slug = preg_replace('~[^-\w]+~', '', $slug);
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
        $parser = new Textile();
        return $parser->textileThis($this->body);
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
