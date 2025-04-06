<center>
    <h1> Inscription </h1>
        <link rel="stylesheet" type="text/css" href="css/styles.css">
    <?php
    echo "<a href='index.php?inscription=inscription'><button class='btn-blue'>Appuyer pour s`inscrire</button></a><br>";

    $inscription = isset($_GET['inscription']) ? $_GET['inscription'] : '';

    switch ($inscription) {
        case "inscription":
            echo '<form method="post">
        <table>
            <tr>
                <td> Nom </td>
                <td><input type="text" name="nomUser"></td>
            </tr>
            <tr>
                <td> Prenom </td>
                <td><input type="text" name="prenomUser"></td>
            </tr>
            <tr>
                <td> Adresse Postale </td>
                <td><input type="text" name="adresseUser"></td>
            </tr>
            <tr>
                <td> Date de Naissance </td>
                <td><input type="date" name="dateNaissanceUser"></td>
            </tr>
            <tr>
                <td>Sexe</td>
                <td>
                    <select name="sexeUser">
                        <option value="M">Masculin</option>
                        <option value="F">Féminin</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Adresse Email </td>
                <td><input type="email" name="emailUser"></td>
            </tr>
            <tr>
                <td> Mot de Passe </td>
                <td><input type="password" name="mdpUser"></td>
            </tr>
            <tr>
                <td> <input type="reset" name="Annuler" value="Annuler" class="table-success"> </td>
                <td><input type="submit" name="InscriptionParticulier" value="Inscription" class="table-success"></td>
            </tr>
        </table>
    
    </form>';
            break;
        case "use" :
            echo "use";
            break;
    }
    ?>

    <style>
        .btn-green {
            background-color: #2E6E49;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .btn-green:hover {
            background-color: #245c3d;
        }

        .btn-green:active {
            background-color: #1b472f;
        }
    </style>
</center>