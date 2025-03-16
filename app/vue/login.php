<?php include '../../includes/header.php'; ?>

    <h2>Connexion</h2>
<?php if (isset($error)): ?>
    <div class="error"><?= $error ?></div>
<?php endif; ?>
    <form method="post">
        <label for="username">Nom d'utilisateur :</label>
        <input type="text" id="username" name="username" required>
        <label for="password">Mot de passe :</label>
        <input type="password" id="password" name="password" required>
        <button type="submit">Se connecter</button>
    </form>

<?php include '../../includes/footer.php'; ?>