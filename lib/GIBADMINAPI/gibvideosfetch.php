<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

// Check connection
if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Handle DELETE request for deleting a video
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    $videoId = isset($data['id']) ? intval($data['id']) : null;

    if (!$videoId) {
        http_response_code(400);
        echo json_encode(array("error" => "Video ID is missing in the request"));
        exit;
    }

    $videoId = mysqli_real_escape_string($conn, $videoId);

    $sql = "DELETE FROM gibvideos WHERE id = $videoId";
    $result = $conn->query($sql);

    if ($result === false) {
        http_response_code(500);
        echo json_encode(array("error" => "Failed to delete video. " . $conn->error));
    } else {
        echo json_encode(array("message" => "Video deleted successfully"));
    }
    exit;
}

// Fetch all videos grouped by selectedDate and event_name
$selectQuery = "SELECT id, event_name, selectedDate, GROUP_CONCAT(videos_name) as videos_names, GROUP_CONCAT(videos_path) as videos_paths, GROUP_CONCAT(thumbnail_path) as thumbnail_paths FROM gibvideos GROUP BY event_name, selectedDate";
$result = $conn->query($selectQuery);

// Store video details in an array
$videos = array();
while ($row = $result->fetch_assoc()) {
    $videos[] = array(
        'id' => $row['id'],
        'event_name' => $row['event_name'],
        'selectedDate' => $row['selectedDate'],
        'videos' => array_map(function($name, $path, $thumb) {
            return array(
                'videos_name' => $name,
                'videos_path' => 'http://localhost/GIB_ADMIN/lib/GIBADMINAPI/' . $path,
                'thumbnail_path' => 'http://localhost/GIB_ADMIN/lib/GIBADMINAPI/' . $thumb,
            );
        }, explode(',', $row['videos_names']), explode(',', $row['videos_paths']), explode(',', $row['thumbnail_paths']))
    );
}

// Close database connection
$conn->close();

// Return JSON response with video details
header('Content-Type: application/json');
echo json_encode($videos);
?>
