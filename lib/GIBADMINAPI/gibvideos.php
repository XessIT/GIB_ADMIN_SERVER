<?php
error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $eventName = $_POST['event_name'];
    $selectedDate = $_POST['selected_date'];

    $video = $_FILES['video'];

    $target_dir = "videouploads/";
    $videoPath = $target_dir . basename($video["name"]);
    $videoType = strtolower(pathinfo($videoPath, PATHINFO_EXTENSION));

    if (!in_array($videoType, ['mp4', 'avi', 'mov'])) {
        echo "Sorry, only MP4, AVI, & MOV files are allowed.";
        exit;
    }

    if (move_uploaded_file($video["tmp_name"], $videoPath)) {
        // Generate thumbnail for the video
        $thumbnailPath = generateThumbnail($videoPath);

        if ($thumbnailPath) {
            $sql = "INSERT INTO gibvideos (event_name, videos_name, videos_path, thumbnail_path, selectedDate) VALUES ('$eventName', '{$video["name"]}', '$videoPath', '$thumbnailPath', '$selectedDate')";
            if ($conn->query($sql) === TRUE) {
                echo "The file " . htmlspecialchars(basename($video["name"])) . " has been uploaded and thumbnail generated.";
            } else {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }
        } else {
            echo "Error generating thumbnail.";
        }
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
}

$conn->close();

// Function to generate video thumbnail
function generateThumbnail($videoPath) {
    // Path to FFmpeg executable
    $ffmpegPath = 'C:/ffmpeg/bin/ffmpeg.exe'; // Update this path based on your installation

    // Path to store the thumbnail
    $thumbnailPath = 'thumbnails/' . uniqid() . '.jpg';

    // Command to generate video thumbnail
    $command = "$ffmpegPath -i $videoPath -ss 00:00:01 -vframes 1 -vf scale=320:-1 $thumbnailPath";

    // Execute the command
    $output = shell_exec($command . ' 2>&1'); // Capture the output for debugging

    // Check if the thumbnail was created
    if (file_exists($thumbnailPath)) {
        return $thumbnailPath;
    } else {
        // Output the error message for debugging
        echo "FFmpeg error: " . $output;
        return false;
    }
}
?>
