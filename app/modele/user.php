<?php
class user {
    private $pdo;

    public function __construct() {
        $this->pdo = Database::getInstance()->getConnection();
    }

    public function register($username, $password) {
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $this->pdo->prepare("insert into users (username, password) values (?, ?)");
        $stmt->bindValue(1, $username, PDO::PARAM_STR);
        $stmt->bindValue(2, $hashedPassword, PDO::PARAM_STR);
        $stmt->execute();
    }

    public function login($username, $password) {
        $stmt = $this->pdo->prepare("select * from users where username = ?");
        $stmt->bindValue(1, $username, PDO::PARAM_STR);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password'])) {
            return $user;
        }
        return false;
    }

    public function isPasswordExpired($userId) {
        $stmt = $this->pdo->prepare("select last_password_change from users where id = ?");
        $stmt->bindValue(1, $userId, PDO::PARAM_INT);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $lastChange = new DateTime($user['last_password_change']);
            $now = new DateTime();
            $interval = $lastChange->diff($now);
            return $interval->days > 90;
        }
        return true;
    }
}
?>