<?php
error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Retrieve the data from the POST request
$eventName = $_POST['event_name'];
$imageName = $_POST['image_name'];
$imageData = $_POST['image_data'];
$selectedDate = $_POST['selected_date'];

// Decode the base64 image data
$imageData = base64_decode($imageData);

// Generate a unique file name
$imageFileName = uniqid() . '_' . $imageName;

// Set the file path
$uploadDir = 'uploads/';
$filePath = $uploadDir . $imageFileName;

// Save the image to the server
if (file_put_contents($filePath, $imageData)) {
    // Insert the image details into the database
       $imageInsertQuery = "INSERT INTO gibimage (event_name, imagename, imagepath, selectedDate) VALUES (?, ?, ?, ?)";
       $statement = $conn->prepare($imageInsertQuery);
       $statement->bind_param('ssss', $eventName, $imageFileName, $filePath, $selectedDate);

    if ($statement->execute()) {
        echo 'Image uploaded successfully.';
    } else {
        echo 'Failed to insert image details into the database.';
    }

    $statement->close();
} else {
    echo 'Failed to save image on the server.';
}

// Close database connection
$conn->close();
?>
