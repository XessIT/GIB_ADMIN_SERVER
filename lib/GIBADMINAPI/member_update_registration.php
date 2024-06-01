 <?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection


if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $id = isset($_GET['id']) ? mysqli_real_escape_string($conn, $_GET['id']) : "";
                 // Fetch data from the registration table
                        $registrationlist = "SELECT * FROM registration where id='$id'";
                        $registrationResult = mysqli_query($conn, $registrationlist);
                        if ($registrationResult && mysqli_num_rows($registrationResult) > 0) {
                            $registrations = array();
                            while ($row = mysqli_fetch_assoc($registrationResult)) {
                                $registrations[] = $row;
                            }
                            echo json_encode($registrations);
                        } else {
                            echo json_encode(array("message" => "No registrations found"));
                        }
              /* else {
                       echo json_encode(array("message" => "Invalid table name"));
                       exit;
                   } */
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
        $place = mysqli_real_escape_string($conn, $data->place);
        $mobile = mysqli_real_escape_string($conn, $data->mobile);
        $email = mysqli_real_escape_string($conn, $data->email);
        $blood_group = mysqli_real_escape_string($conn, $data->blood_group);
        $district = mysqli_real_escape_string($conn, $data->district);
        $chapter = mysqli_real_escape_string($conn, $data->chapter);
        $dob = mysqli_real_escape_string($conn, $data->dob);
        $WAD = mysqli_real_escape_string($conn, $data->WAD);
        $koottam = mysqli_real_escape_string($conn, $data->koottam);
        $kovil = mysqli_real_escape_string($conn, $data->kovil);
        $s_name = mysqli_real_escape_string($conn, $data->s_name);
        $native = mysqli_real_escape_string($conn, $data->native);
        $s_father_koottam = mysqli_real_escape_string($conn, $data->s_father_koottam);
        $s_father_kovil = mysqli_real_escape_string($conn, $data->s_father_kovil);
        $education = mysqli_real_escape_string($conn, $data->education);
        $past_experience = mysqli_real_escape_string($conn, $data->past_experience);
        $marital_status = mysqli_real_escape_string($conn, $data->marital_status);
        $company_name = mysqli_real_escape_string($conn, $data->company_name);
        $company_address = mysqli_real_escape_string($conn, $data->company_address);
        $website = mysqli_real_escape_string($conn, $data->website);
        $b_year = mysqli_real_escape_string($conn, $data->b_year);
        $business_keywords = mysqli_real_escape_string($conn, $data->business_keywords);
        $business_type = mysqli_real_escape_string($conn, $data->business_type);
        $member_type = mysqli_real_escape_string($conn, $data->member_type);
        $gender = mysqli_real_escape_string($conn, $data->gender);

        $updateOfferQuery = "UPDATE `registration` SET
        `first_name`='$first_name',
        `last_name`='$last_name',
        `company_name`='$company_name',
        `member_type`='$member_type',
        `gender`='$gender',
        `place`='$place',
        `mobile`='$mobile',
        `email`='$email',
        `blood_group`='$blood_group',
        `district`='$district',
        `chapter`='$chapter',
        `dob`='$dob',
        `WAD`='$WAD',
        `koottam`='$koottam',
        `kovil`='$kovil',
        `s_name`='$s_name',
        `native`='$native',
        `s_father_koottam`='$s_father_koottam',
        `s_father_kovil`='$s_father_kovil',
        `education`='$education',
        `past_experience`='$past_experience',
        `marital_status`='$marital_status',
        `company_name`='$company_name',
        `company_address`='$company_address',
        `website`='$website',
        `b_year`='$b_year',
        `business_keywords`='$business_keywords',
        `business_type`='$business_type'
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