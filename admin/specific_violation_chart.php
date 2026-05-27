<?php

include("../config/database.php");

$year =
$_GET['year'];

$violation =
$_GET['violation'];

$where =
"WHERE violation_type='$violation'";

if($year != ""){

    $where .=
    " AND YEAR(created_at)='$year'";

}

$query = "

SELECT department,
COUNT(*) AS total

FROM violations

$where

GROUP BY department

";

$result =
db_query( $query);

$labels = [];
$values = [];

while($row = db_fetch_assoc($result)){

    $labels[] = $row['department'];
    $values[] = $row['total'];

}

echo json_encode([
    "labels"=>$labels,
    "values"=>$values
]);

?>