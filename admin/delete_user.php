<?php

include("../config/database.php");

if (isset($_GET['id'])) {

    $id = $_GET['id'];

    $query = "DELETE FROM users WHERE id='$id'";

    db_query( $query);

    header("Location: users.php");
    exit();

}

?>