<?php

session_start();

include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $fullname = db_escape( $_POST['fullname']);
    $username = db_escape( $_POST['username']);
    $email = db_escape( $_POST['email']);
    $role = db_escape( $_POST['role']);

    // HASH PASSWORD
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    // CHECK EMAIL
    $checkEmail = "SELECT * FROM users WHERE email='$email'";
    $emailResult = db_query( $checkEmail);

    if(db_num_rows($emailResult) > 0){

        echo "
        <script>
            alert('Email already exists.');
            window.location='users.php';
        </script>
        ";

        exit();
    }

    // CHECK USERNAME
    $checkUsername = "SELECT * FROM users WHERE username='$username'";
    $usernameResult = db_query( $checkUsername);

    if(db_num_rows($usernameResult) > 0){

        echo "
        <script>
            alert('Username already exists.');
            window.location='users.php';
        </script>
        ";

        exit();
    }

    // INSERT USER
    $query = "INSERT INTO users(fullname, username, email, password, role)
              VALUES('$fullname','$username','$email','$password','$role')";

    db_query( $query);

    echo "
    <script>
        alert('User added successfully.');
        window.location='users.php';
    </script>
    ";

}

?>