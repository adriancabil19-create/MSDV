<?php

// Database Configuration
// Supports both MySQL and PostgreSQL

$db_type = getenv('DB_TYPE') ?: 'mysql';
$host = getenv('DB_HOST') ?: getenv('DB_HOST_EXTERNAL') ?: "localhost";
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
    // Prefer explicit IPv4 A-record lookup to avoid IPv6 "Network is unreachable" errors
    $resolved_ip = null;
    $ipv4_list = @gethostbynamel($host);
    if ($ipv4_list !== false && count($ipv4_list) > 0) {
        $resolved_ip = $ipv4_list[0];
    } else {
        $a_records = @dns_get_record($host, DNS_A);
        if ($a_records !== false && count($a_records) > 0 && !empty($a_records[0]['ip'])) {
            $resolved_ip = $a_records[0]['ip'];
        }
    }

    $connection_string = "host=$host port=$port dbname=$db_name user=$user password=$pass";
    if (!empty($resolved_ip) && filter_var($resolved_ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
        $connection_string .= " hostaddr=$resolved_ip";
    }
    if (!empty($sslmode)) {
        $connection_string .= " sslmode=$sslmode";
    }

    $conn = @pg_connect($connection_string);

    if (!$conn) {
        // Avoid calling pg_last_error() without an explicit connection (deprecated).
        $error = '';
        $last = error_get_last();
        if (!empty($last['message'])) {
            $error = $last['message'];
        } else {
            $error = 'Unknown error';
        }

        // Mask password for output
        $display_conn = preg_replace('/password=[^\s]+/', 'password=****', $connection_string);
        die("PostgreSQL Connection Failed: " . $error . " — " . $display_conn);
    }
}
else {
    die("Unsupported database type: $db_type");
}

?>