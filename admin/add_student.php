<?php

include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $student_id = db_escape( $_POST['student_id']);
    $fullname = db_escape( $_POST['fullname']);
    $course = db_escape( $_POST['course']);
    $year_level = db_escape( $_POST['year_level']);
    $department = db_escape( $_POST['department']);

    $query = "INSERT INTO students
            (student_id, fullname, course, year_level, department)

            VALUES

            ('$student_id','$fullname','$course','$year_level','$department')";

    db_query( $query);

    header("Location: students.php");
    exit();

}

?>