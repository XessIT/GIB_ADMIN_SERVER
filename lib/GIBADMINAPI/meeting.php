<?php
error_log($_SERVER['REQUEST_METHOD']);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
     $district = isset($_GET['district']) ? mysqli_real_escape_string($conn, $_GET['district']) : "";
     $chapter = isset($_GET['chapter']) ? mysqli_real_escape_string($conn, $_GET['chapter']) : "";

     $register_meetinglist = "SELECT * FROM meeting WHERE district ='$district' AND chapter ='$chapter'";
     $register_meetingResult = mysqli_query($conn, $register_meetinglist);
     $register_meeting = array(); // Initialize the array

     if ($register_meetingResult) {
         while ($row = mysqli_fetch_assoc($register_meetingResult)) {
             $register_meeting[] = $row;
         }
     }

     echo json_encode($register_meeting); // Always encode the array
 }


mysqli_close($conn);
?>
