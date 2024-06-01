<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $meetingname = "SELECT * FROM meeting_type";
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

 else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
     // Handle the insert/update/delete actions
    $data = json_decode(file_get_contents("php://input"));

    $meeting_type = mysqli_real_escape_string($conn, $data->meeting_type);
        $insertUserQuery = "INSERT INTO `meeting_type`(`meeting_type`) VALUES ('$meeting_type')";

       $arr = [];
       $insertUserResult = mysqli_query($conn, $insertUserQuery);
       if($insertUserResult) {
          $arr["Success"] = true;
       } else {
          $arr["Success"] = false;
       }
       echo json_encode($arr);
 }

 // Handle PUT request for updating data
  else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
      // Parse JSON payload from the request
      $data = json_decode(file_get_contents("php://input"));

      // Escape and sanitize data
      $meeting_type = mysqli_real_escape_string($conn, $data->meeting_type);
      $id = mysqli_real_escape_string($conn, $data->id);
      // Update query
      $updateQuery = "UPDATE meeting_type SET meeting_type = '$meeting_type' WHERE id = $id";
        if (mysqli_query($conn, $updateQuery)) {
          echo "Record updated successfully";
      } else {
          echo "Error updating record: " . mysqli_error($conn);
      }
  }

  else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
      $id = isset($_GET['id']) ? $_GET['id'] : null;

      if (!$id) {
          echo json_encode(array("error" => "ID is missing in the request"));
          exit;
      }

      $id = mysqli_real_escape_string($conn, $id);

      $sql = "DELETE FROM meeting_type WHERE id = '$id'";
      $result = $conn->query($sql);

      if ($result === false) {
          echo json_encode(array("error" => "Query failed: " . $conn->error));
      } else {
          echo json_encode(array("message" => "Meeting Type deleted successfully"));
      }
  }

 mysqli_close($conn);
 ?>