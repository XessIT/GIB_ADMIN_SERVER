<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection
// Check if memberId is passed from the frontend
if (isset($_GET['memberId'])) {
    $memberId = $_GET['memberId'];



    if ($conn->connect_error) {
        die('Connection failed: ' . $conn->connect_error);
    }

    $sql = "SELECT ads_image AS imagepaths FROM ads WHERE id = ?"; // Assuming member_id is a column in your ads table
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $memberId);
    $stmt->execute();
    $result = $stmt->get_result();

    $imageData = array();

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            if (strpos($row['imagepaths'], ',') !== false) {
                $row['imagepaths'] = array_map('trim', explode(',', $row['imagepaths']));
            } else {
                $row['imagepaths'] = array(trim($row['imagepaths']));
            }
            $imageData[] = $row;
        }
        echo json_encode($imageData);
    } else {
        echo json_encode(array('error' => 'Image not found for memberId: ' . $memberId));
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(array('error' => 'No memberId provided.'));
}
?>
