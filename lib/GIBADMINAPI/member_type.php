<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
//include "connection.php";

include 'connection.php';  // Ensure you include your database connection


// Check if the connection is successful
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT DISTINCT member_type FROM member_type";
$result = array();
$res = $con->query($sql);

// Check if the query was successful
if ($res === false) {
    die("Query failed: " . $con->error);
}

// Check if there are rows returned
if ($res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        $result[] = $row;
    }
}


// Output the JSON-encoded result
echo json_encode($result);

?>