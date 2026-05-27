<?php

include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $id = $_POST['id'];

    $fullname = db_escape( $_POST['fullname']);
    $username = db_escape( $_POST['username']);
    $email = db_escape( $_POST['email']);
    $role = db_escape( $_POST['role']);

    $query = "UPDATE users SET
                fullname='$fullname',
                username='$username',
                email='$email',
                role='$role'
              WHERE id='$id'";

    db_query( $query);

    header("Location: users.php");
    exit();

}

?>