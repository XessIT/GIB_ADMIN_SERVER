<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $meetingname = "SELECT * FROM g2g";
               $meetingResult = mysqli_query($conn, $meetingname);
               if ($meetingResult && mysqli_num_rows($meetingResult) > 0) {
                   $meeting = array();
                   while ($row = mysqli_fetch_assoc($meetingResult)) {
                       $meeting[] = $row;
                   }
                   echo json_encode($meeting);
               } else {
                   echo json_encode(array("message" => "No meeting found"));
               }
      }

 mysqli_close($conn);
 ?>