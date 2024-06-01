<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

 // Handle PUT request for updating data
 if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
     $data = json_decode(file_get_contents("php://input"), true);
     $meetingId = $data['meeting_id']; // Assuming 'meeting_id' is sent from the client

     // Update qr_status to 'Generated' for the meeting with the given ID
     $sql = "UPDATE meeting SET qr_status = 'Generated' WHERE id = $meetingId";

     if (mysqli_query($conn, $sql)) {
         echo "Record updated successfully";
     } else {
         echo "Error updating record: " . mysqli_error($conn);
     }
 }



 mysqli_close($conn);
 ?>