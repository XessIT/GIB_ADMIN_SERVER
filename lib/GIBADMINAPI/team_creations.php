<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection


if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $district = isset($_GET['district']) ? mysqli_real_escape_string($conn, $_GET['district']) : "";
    $chapter = isset($_GET['chapter']) ? mysqli_real_escape_string($conn, $_GET['chapter']) : "";

              // Fetch team names based on district and chapter
                $query = "SELECT * FROM team_creations";
                $result = mysqli_query($conn, $query);
                 if ($result && mysqli_num_rows($result) > 0) {
                     $teamNames = array();
                     while ($row = mysqli_fetch_assoc($result)) {
                         $teamNames[] = $row;
                     }
                     echo json_encode($teamNames);
                 } else {
                     echo json_encode(array("message" => "No team names found"));
                 }
}

 else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
          // Handle the insert/update/delete actions
          $data = json_decode(file_get_contents("php://input"));

          $district = mysqli_real_escape_string($conn, $data->district);
          $chapter = mysqli_real_escape_string($conn, $data->chapter);
          $team_name = mysqli_real_escape_string($conn, $data->team_name);

          // Check for duplicate entry
          $checkDuplicateQuery = "SELECT * FROM `team_creations` WHERE `district` = '$district' AND `chapter` = '$chapter' AND `team_name` = '$team_name'";
          $result = mysqli_query($conn, $checkDuplicateQuery);

          $arr = [];

          if (mysqli_num_rows($result) > 0) {
              // Duplicate found
              $arr["Success"] = false;
              $arr["Message"] = "Duplicate entry";
          } else {
              // No duplicate, proceed with insert
              $insertUserQuery = "INSERT INTO `team_creations`(`team_name`, `district`, `chapter`) VALUES ('$team_name', '$district', '$chapter')";
              $insertUserResult = mysqli_query($conn, $insertUserQuery);
              if ($insertUserResult) {
                  $arr["Success"] = true;
              } else {
                  $arr["Success"] = false;
                  $arr["Message"] = "Failed to insert";
              }
          }

          echo json_encode($arr);
      }

 // Handle PUT request for updating data
  else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
           // Parse JSON payload from the request
           $data = json_decode(file_get_contents("php://input"));

           // Escape and sanitize data
           $team_name = mysqli_real_escape_string($conn, $data->team_name);
           $id = mysqli_real_escape_string($conn, $data->id);

           // Get current district and chapter for the id
           $currentDataQuery = "SELECT district, chapter FROM team_creations WHERE id = $id";
           $currentDataResult = mysqli_query($conn, $currentDataQuery);
           if ($currentDataResult && mysqli_num_rows($currentDataResult) > 0) {
               $currentData = mysqli_fetch_assoc($currentDataResult);
               $district = $currentData['district'];
               $chapter = $currentData['chapter'];

               // Check for duplicate entry
               $checkDuplicateQuery = "SELECT * FROM team_creations WHERE team_name = '$team_name' AND district = '$district' AND chapter = '$chapter' AND id != $id";
               $result = mysqli_query($conn, $checkDuplicateQuery);

               if (mysqli_num_rows($result) > 0) {
                   // Duplicate found
                   $arr = ["Success" => false, "Message" => "Duplicate entry"];
               } else {
                   // No duplicate, proceed with update
                   $updateQuery = "UPDATE team_creations SET team_name = '$team_name' WHERE id = $id";
                   if (mysqli_query($conn, $updateQuery)) {
                       $arr = ["Success" => true];
                   } else {
                       $arr = ["Success" => false, "Message" => "Error updating record: " . mysqli_error($conn)];
                   }
               }
           } else {
               $arr = ["Success" => false, "Message" => "Record not found"];
           }

           echo json_encode($arr);
       }

  else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
      $id = isset($_GET['id']) ? $_GET['id'] : null;

      if (!$id) {
          echo json_encode(array("error" => "ID is missing in the request"));
          exit;
      }

      $id = mysqli_real_escape_string($conn, $id);

      $sql = "DELETE FROM team_creations WHERE id = '$id'";
      $result = $conn->query($sql);

      if ($result === false) {
          echo json_encode(array("error" => "Query failed: " . $conn->error));
      } else {
          echo json_encode(array("message" => "Member Type deleted successfully"));
      }
  }

 mysqli_close($conn);
 ?>