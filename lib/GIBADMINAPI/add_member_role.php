<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $rolename = "SELECT * FROM member_role";
               $roleResult = mysqli_query($conn, $rolename);
               if ($roleResult && mysqli_num_rows($roleResult) > 0) {
                   $role = array();
                   while ($row = mysqli_fetch_assoc($roleResult)) {
                       $role[] = $row;
                   }
                   echo json_encode($role);
               } else {
                   echo json_encode(array("message" => "No meeting found"));
               }
}

 else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
     // Handle the insert/update/delete actions
    $data = json_decode(file_get_contents("php://input"));

    $member_role = mysqli_real_escape_string($conn, $data->member_role);
        $insertQuery = "INSERT INTO `member_role`(`role`) VALUES ('$member_role')";

       $arr = [];
       $insertResult = mysqli_query($conn, $insertQuery);
       if($insertResult) {
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
      $member_role = mysqli_real_escape_string($conn, $data->member_role);
      $id = mysqli_real_escape_string($conn, $data->id);
      // Update query
      $updateQuery = "UPDATE member_role SET role = '$member_role' WHERE id = $id";
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

      $sql = "DELETE FROM member_role WHERE id = '$id'";
      $result = $conn->query($sql);

      if ($result === false) {
          echo json_encode(array("error" => "Query failed: " . $conn->error));
      } else {
          echo json_encode(array("message" => "Meeting Type deleted successfully"));
      }
  }

 mysqli_close($conn);
 ?>