<?php
class database {
    private static $instance = null;
    private $pdo;

    private function __construct() {
        $config = include '../config/config.php';
        $db = $config['db'];
        $this->pdo = new PDO(
            "mysql:host={$db['host']};dbname={$db['dbname']}",
            $db['user'],
            $db['password']
        );
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->pdo;
    }
}
?>