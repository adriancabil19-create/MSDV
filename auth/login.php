<?php

session_start();

include("../config/database.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $username = db_escape($_POST['username']);
    $password = $_POST['password'];

    $query = "SELECT * FROM users WHERE username='$username'";
    $result = db_query($query);

    if ($result && db_num_rows($result) > 0) {

        $user = db_fetch_assoc($result);

        if (password_verify($password, $user['password'])) {

            $_SESSION['user_id'] = $user['id'];
            $_SESSION['fullname'] = $user['fullname'];
            $_SESSION['role'] = $user['role'];

            if ($user['role'] == 'admin') {
                header("Location: ../admin/dashboard.php");
            }

            elseif ($user['role'] == 'teacher') {
                header("Location: ../teacher/report_violation.php");
            }

            elseif ($user['role'] == 'csu') {
                header("Location: ../csu/report_violation.php");
            }

            elseif ($user['role'] == 'jassu') {
                header("Location: ../jassu/report_violation.php");
            }

        } else {
            header("Location: ../index.html?error=invalid_password");
            exit();
        }

    } else {
        header("Location: ../index.html?error=user_not_found");
        exit();
    }

}

?>