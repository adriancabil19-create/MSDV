<?php

session_start();

include("../config/database.php");

if(!isset($_SESSION['user_id'])){

    header("Location: ../index.html");
    exit();

}

if($_SESSION['role'] != 'admin'){

    header("Location: ../index.html");
    exit();

}

/* ADMIN DELETE PASSWORD */
$adminPassword = "admin123";

/* FORM DATA */
$student_id =
db_escape(
    $_POST['student_id']
);

$password =
$_POST['delete_password'];

/* VERIFY PASSWORD */
if($password != $adminPassword){

    echo "

    <script>

        alert('Incorrect deletion password.');

        window.location='students.php';

    </script>

    ";

    exit();

}

/* DELETE VIOLATIONS FIRST */
db_query(
    "DELETE FROM violations
     WHERE student_id='$student_id'"
);

/* DELETE STUDENT */
db_query(
    "DELETE FROM students
     WHERE student_id='$student_id'"
);

echo "

<script>

    alert('Student deleted successfully.');

    window.location='students.php';

</script>

";

?>