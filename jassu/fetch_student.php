<?php

include("../config/database.php");

if(isset($_POST['student_id'])){

    $student_id = db_escape( $_POST['student_id']);

    $query = "SELECT * FROM students WHERE student_id='$student_id'";

    $result = db_query( $query);

    if(db_num_rows($result) > 0){

        $student = db_fetch_assoc($result);

        echo json_encode($student);

    }

}
?>