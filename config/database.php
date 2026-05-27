<?php

// Database Configuration
// Supports both MySQL and PostgreSQL

$db_type = getenv('DB_TYPE') ?: 'mysql';
$host = getenv('DB_HOST') ?: "localhost";
$user = getenv('DB_USER') ?: "root";
$pass = getenv('DB_PASS') ?: "";
$db_name = getenv('DB_NAME') ?: "mcc_discipline_system";
$port = getenv('DB_PORT') ?: ($db_type === 'pgsql' ? 5432 : 3306);
$sslmode = getenv('DB_SSLMODE') ?: '';

// MySQL Connection (default)
if ($db_type === 'mysql') {
    $conn = mysqli_connect($host, $user, $pass, $db_name, $port);
    
    if (!$conn) {
        die("MySQL Connection Failed: " . mysqli_connect_error());
    }
    
    // Set charset
    mysqli_set_charset($conn, "utf8mb4");
}
// PostgreSQL Connection
elseif ($db_type === 'pgsql') {
    $connection_string = "host=$host port=$port dbname=$db_name user=$user password=$pass";
    if (!empty($sslmode)) {
        $connection_string .= " sslmode=$sslmode";
    }
    $conn = pg_connect($connection_string);
    
    if (!$conn) {
        die("PostgreSQL Connection Failed");
    }
}
else {
    die("Unsupported database type: $db_type");
}

?>