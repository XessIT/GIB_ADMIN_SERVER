<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT event_name, selectedDate,id, GROUP_CONCAT(imagepath) AS imagepaths
            FROM gibachievement
            GROUP BY event_name, selectedDate";
    $result = $conn->query($sql);

    $imageData = array();

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $row['imagepaths'] = explode(',', $row['imagepaths']);
            $imageData[] = $row;
        }
        echo json_encode($imageData);
    } else {
        echo json_encode(array('error' => 'Image not found.'));
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
           // Get the raw input data from the request body
           $input_data = file_get_contents("php://input");

           // Check if the input data is valid JSON
           if (!empty($input_data)) {
               // Decode the JSON data into an associative array
               $params = json_decode($input_data, true);

               // Check if 'id' is present in the decoded data
               if (isset($params['id'])) {
                   // Extract the image ID from the decoded data
                   $imageId = intval($params['id']);

                   // Check if the image ID is valid
                   if ($imageId <= 0) {
                       echo json_encode(array("error" => "Invalid Image ID"));
                       exit;
                   }

                   // Sanitize the image ID to prevent SQL injection
                   $imageId = mysqli_real_escape_string($conn, $imageId);

                   // Prepare and execute the DELETE query
                   $sql = "DELETE FROM gibachievement WHERE id = $imageId";
                   $result = $conn->query($sql);

                   // Check if the query execution was successful
                   if ($result === false) {
                       echo json_encode(array("error" => "Query failed: " . $conn->error));
                   } else {
                       echo json_encode(array("message" => "Image deleted successfully"));
                   }
               } else {
                   echo json_encode(array("error" => "Image ID is missing in the request"));
               }
           } else {
               echo json_encode(array("error" => "Invalid JSON data in the request"));
           }
       }

$conn->close();
?>
