<?php
class authentification {
    private $userModel;

    public function __construct() {
        $this->userModel = new User();
    }

    public function login() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $username = $_POST['username'];
            $password = $_POST['password'];

            $user = $this->userModel->login($username, $password);

            if ($user) {
                if ($this->userModel->isPasswordExpired($user['id'])) {
                    $error = "Votre mot de passe a expiré. Veuillez le changer.";
                    include '../views/auth/login.php';
                } else {
                    $_SESSION['user'] = $user;
                    header("Location: /home");
                }
            } else {
                $error = "Identifiants incorrects.";
                include '../views/auth/login.php';
            }
        } else {
            include '../views/auth/login.php';
        }
    }

    public function register() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $username = $_POST['username'];
            $password = $_POST['password'];

            $this->userModel->register($username, $password);
            header("Location: /login");
        } else {
            include '../views/auth/register.php';
        }
    }

    public function logout() {
        session_destroy();
        header("Location: /login");
    }
}
?>