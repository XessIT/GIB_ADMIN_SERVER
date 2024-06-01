<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if district and chapter are provided in the GET request
if(isset($_GET['district']) && isset($_GET['chapter'])){
    $district = $_GET['district'];
    $chapter = $_GET['chapter'];

    // Prepare SQL statement with prepared statements to prevent SQL injection
    $stmt = $conn->prepare("SELECT team_name FROM team_creations WHERE district = ? AND chapter = ?");
    $stmt->bind_param("ss", $district, $chapter);
    $stmt->execute();

    // Get results
    $result = $stmt->get_result();

    // Check if there are results
    if ($result->num_rows > 0) {
        // Output data of each row
        $rows = array();
        while($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
        echo json_encode($rows); // Output JSON format
    } else {
        echo json_encode([]); // Return an empty array if no results are found
    }

    // Close statement
    $stmt->close();
} else {
    echo "District and chapter not provided.";
}

// Close connection
$conn->close();
?>
