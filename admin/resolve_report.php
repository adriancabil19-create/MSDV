<?php

include("../config/database.php");

if(isset($_GET['id'])){

    $id = $_GET['id'];

    $query = "UPDATE violations
              SET status='Resolved'
              WHERE id='$id'";

    db_query( $query);

    header("Location: reports.php");
    exit();

}
?>