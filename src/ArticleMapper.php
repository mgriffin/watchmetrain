<?php
namespace WMT;

class ArticleMapper
{
    protected $conn;

    public function __construct($conn)
    {
        if ($conn !== null) {
            $this->conn = $conn;
        }
    }

    public function getList()
    {
        $sql = "SELECT * FROM articles LIMIT 5";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        $rows = $stmt->fetchAll();

        $result = array();
        foreach ($rows as $row) {
            $result[] = $this->createArticleFromRow($row);
        }

        return $result;
    }

    public function createArticleFromRow($row)
    {
        $article = new Article();
        $article->setTitle($row['title']);

        return $article;
    }
}
