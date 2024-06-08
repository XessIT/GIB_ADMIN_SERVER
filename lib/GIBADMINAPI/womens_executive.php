 <?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  $member_type = isset($_GET['member_type']) ? mysqli_real_escape_string($conn, $_GET['member_type']) : "";
  $admin_rights = isset($_GET['admin_rights']) ? mysqli_real_escape_string($conn, $_GET['admin_rights']) : "";
  $block_status = isset($_GET['block_status']) ? mysqli_real_escape_string($conn, $_GET['block_status']) : "";

  // Corrected filtering conditions
  $registrationlist = "SELECT * FROM registration WHERE member_type='$member_type' AND admin_rights = 'Accepted' AND block_status = 'UnBlock'";
  $registrationResult = mysqli_query($conn, $registrationlist);

  if ($registrationResult && mysqli_num_rows($registrationResult) > 0) {
    $registrations = array();
    while ($row = mysqli_fetch_assoc($registrationResult)) {
      $registrations[] = $row;
    }
    echo json_encode($registrations);
  } else {
    echo json_encode(array("message" => "No registrations found with the specified criteria"));
  }
}


else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle the insert/update/delete actions
   $data = json_decode(file_get_contents("php://input"));
   $imagename = mysqli_real_escape_string($conn, $data->imagename);
    echo "Imagename: $imagename";
   $imagedata = mysqli_real_escape_string($conn, $data->imagedata);
   $name = mysqli_real_escape_string($conn, $data->name);
   $discount = mysqli_real_escape_string($conn, $data->discount);
   $user_id = mysqli_real_escape_string($conn, $data->user_id);
   $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
   $validity = mysqli_real_escape_string($conn, $data->validity);
   $first_name = mysqli_real_escape_string($conn, $data->first_name);
   $last_name = mysqli_real_escape_string($conn, $data->last_name);
   $mobile = mysqli_real_escape_string($conn, $data->mobile);
   $company_name = mysqli_real_escape_string($conn, $data->company_name);
   $block_status = mysqli_real_escape_string($conn, $data->block_status);
    $path = "offers/$imagename";
       $insertUserQuery = "INSERT INTO `offers`(`user_id`, `offer_type`, `name`, `discount`, `validity`, `first_name`, `last_name`, `mobile`, `company_name`, `block_status`, `offer_image`)
      VALUES ('$user_id','$offer_type','$name','$discount','$validity', '$first_name', '$last_name', '$mobile', '$company_name', '$block_status', '$path')";
      file_put_contents($path, base64_decode($imagedata));
      $arr = [];
      $insertUserResult = mysqli_query($conn, $insertUserQuery);
      if($insertUserResult) {
         $arr["Success"] = true;
      } else {
         $arr["Success"] = false;
      }
      echo json_encode($arr);

}

else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));
        $first_name = mysqli_real_escape_string($conn, $data->first_name);
        $last_name = mysqli_real_escape_string($conn, $data->last_name);
        $id = mysqli_real_escape_string($conn, $data->id);
        $company_name = mysqli_real_escape_string($conn, $data->company_name);
        $place = mysqli_real_escape_string($conn, $data->place);
        $mobile = mysqli_real_escape_string($conn, $data->mobile);
        $email = mysqli_real_escape_string($conn, $data->email);
        $blood_group = mysqli_real_escape_string($conn, $data->blood_group);

        $updateOfferQuery = "UPDATE `registration` SET
        `first_name`='$first_name',
        `last_name`='$last_name',
        `company_name`='$company_name',
        `place`='$place',
        `mobile`='$mobile',
        `email`='$email',
        `blood_group`='$blood_group'
         WHERE `id`='$id'";
        $updateOfferResult = mysqli_query($conn, $updateOfferQuery);

        if ($updateOfferResult) {
            echo "Profile updated successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }

}

else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $ID = isset($_GET['ID']) ? $_GET['ID'] : null;

    if (!$ID) {
        echo json_encode(array("error" => "ID is missing in the request"));
        exit;
    }

    $ID = mysqli_real_escape_string($conn, $ID);

    $sql = "DELETE FROM offers WHERE ID = '$ID'";
    $result = $conn->query($sql);

    if ($result === false) {
        echo json_encode(array("error" => "Query failed: " . $conn->error));
    } else {
        echo json_encode(array("message" => "Offer deleted successfully"));
    }
}


mysqli_close($conn);
?>