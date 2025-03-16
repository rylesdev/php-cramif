<?php include '../../includes/header.php'; ?>

    <h2>Inscription</h2>
    <form method="post">
        <label for="username">Nom d'utilisateur :</label>
        <input type="text" id="username" name="username" required>
        <label for="password">Mot de passe :</label>
        <input type="password" id="password" name="password" required>
        <button type="submit">S'inscrire</button>
    </form>

<?php include '../../includes/footer.php'; ?>