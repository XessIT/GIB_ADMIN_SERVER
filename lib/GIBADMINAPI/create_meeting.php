<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $currentDate = date("Y-m-d");
   $meetingname = "SELECT * FROM meeting WHERE meeting_date >= '$currentDate'";
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

        $meeting_date = mysqli_real_escape_string($conn, $data->meeting_date);
        $from_time = mysqli_real_escape_string($conn, $data->from_time);
        $to_time = mysqli_real_escape_string($conn, $data->to_time);
        $district = mysqli_real_escape_string($conn, $data->district);
        $chapter = mysqli_real_escape_string($conn, $data->chapter);
        $meeting_type = mysqli_real_escape_string($conn, $data->meeting_type);
        $place = mysqli_real_escape_string($conn, $data->place);
        $team_name = mysqli_real_escape_string($conn, $data->team_name);
        $meeting_name = mysqli_real_escape_string($conn, $data->meeting_name);
        $registration_closing_date = mysqli_real_escape_string($conn, $data->registration_closing_date);
        $registration_closing_time = mysqli_real_escape_string($conn, $data->registration_closing_time);
        $registration_opening_date = mysqli_real_escape_string($conn, $data->registration_opening_date);
        $registration_opening_time = mysqli_real_escape_string($conn, $data->registration_opening_time);
        $member_types = $data->member_type; // Assuming member_type is sent as an array from Flutter

        $arr = [];
        foreach ($member_types as $member_type) {
            // Prepared statement to prevent SQL injection
            $insertUserQuery = "INSERT INTO `meeting` (`meeting_date`, `from_time`, `to_time`, `district`, `chapter`, `meeting_type`, `member_type`, `team_name`, `place`, `meeting_name`, `registration_closing_date`, `registration_closing_time`, `registration_opening_date`, `registration_opening_time`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            $stmt = $conn->prepare($insertUserQuery);
            $stmt->bind_param("ssssssssssssss", $meeting_date, $from_time, $to_time, $district, $chapter, $meeting_type, $member_type, $team_name, $place, $meeting_name, $registration_closing_date, $registration_closing_time, $registration_opening_date, $registration_opening_time);

            if ($stmt->execute()) {
                $arr["Success"][] = true; // Store success status for each insertion
            } else {
                $arr["Success"][] = false;
            }
        }
        echo json_encode($arr);
  }

 // Handle PUT request for updating data
  else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
      // Parse JSON payload from the request
      $data = json_decode(file_get_contents("php://input"));

      // Escape and sanitize data
      $member_category = mysqli_real_escape_string($conn, $data->member_category);
      $id = mysqli_real_escape_string($conn, $data->id);
      // Update query
      $updateQuery = "UPDATE meeting SET member_category = '$member_category' WHERE id = $id";
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

      $sql = "DELETE FROM member_category WHERE id = '$id'";
      $result = $conn->query($sql);

      if ($result === false) {
          echo json_encode(array("error" => "Query failed: " . $conn->error));
      } else {
          echo json_encode(array("message" => "Member Type deleted successfully"));
      }
  }

 mysqli_close($conn);
 ?>