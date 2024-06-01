<?php
 error_log($_SERVER['REQUEST_METHOD']);
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "member_type") {
      $offerlist = "SELECT member_type FROM member_type";
                $offerResult = mysqli_query($conn, $offerlist);
                if ($offerResult && mysqli_num_rows($offerResult) > 0) {
                    $offers = array();
                    while ($row = mysqli_fetch_assoc($offerResult)) {
                        $offers[] = $row;
                    }
                    echo json_encode($offers);
                } else {
                    echo json_encode(array("message" => "No member_type found"));
                }
    }
    else if($table == "subscription"){
   $meetingname = "SELECT * FROM subscription";
               $meetingResult = mysqli_query($conn, $meetingname);
               if ($meetingResult && mysqli_num_rows($meetingResult) > 0) {
                   $meeting = array();
                   while ($row = mysqli_fetch_assoc($meetingResult)) {
                       $meeting[] = $row;
                   }
                   echo json_encode($meeting);
               } else {
                   echo json_encode(array("message" => "No subscription found"));
                }
               }
               else if($table == "subscription_member_type"){
                       if (isset($_GET['district']) && isset($_GET['chapter'])) {
                           $district = mysqli_real_escape_string($conn, $_GET['district']);
                           $chapter = mysqli_real_escape_string($conn, $_GET['chapter']);
                           $userlist = "SELECT DISTINCT member_type FROM subscription WHERE district = '$district' AND chapter = '$chapter'";
                           $userResult = mysqli_query($conn, $userlist);
                           if ($userResult && mysqli_num_rows($userResult) > 0) {
                               $users = array();
                               while ($row = mysqli_fetch_assoc($userResult)) {
                                   $users[] = $row;
                               }
                               echo json_encode($users);
                           } else {
                               echo json_encode(array("message" => "No users found"));
                           }
                       } else {
                           echo json_encode(array("message" => "Missing parameters"));
                       }
               }

                else if ($table == "subscription_member_category") {
                       if (isset($_GET['member_type']) && isset($_GET['chapter']) && isset($_GET['district'])) {
                           $district = mysqli_real_escape_string($conn, $_GET['district']);
                           $chapter = mysqli_real_escape_string($conn, $_GET['chapter']);
                           $member_type = mysqli_real_escape_string($conn, $_GET['member_type']);

                           $userlist = "SELECT DISTINCT member_category FROM subscription WHERE district = '$district' AND chapter = '$chapter' AND member_type = '$member_type'";
                           $userResult = mysqli_query($conn, $userlist);
                           if ($userResult && mysqli_num_rows($userResult) > 0) {
                               $users = array();
                               while ($row = mysqli_fetch_assoc($userResult)) {
                                   $users[] = $row;
                               }
                               echo json_encode($users);
                           } else {
                               echo json_encode(array("message" => "No users found"));
                           }
                       } else {
                           echo json_encode(array("message" => "Missing parameters"));
                       }
                   }
               else if($table == "registration"){
               $member_id = isset($_GET['member_id']) ? mysqli_real_escape_string($conn, $_GET['member_id']) : "";
               $mobile = isset($_GET['mobile']) ? mysqli_real_escape_string($conn, $_GET['mobile']) : "";
                if(isset($_GET['member_id'])){
                    $getmobilelist = "SELECT * FROM registration WHERE member_id ='$member_id'  ";
                    }
                    else {
                     $getmobilelist = "SELECT member_id FROM registration";
                    }
                    $getmobileResult = mysqli_query($conn, $getmobilelist);

                    $getmobile = array();

                    if ($getmobileResult) {
                        while ($row = mysqli_fetch_assoc($getmobileResult)) {
                            $getmobile[] = $row;
                        }
                    }
                  echo json_encode($getmobile);
                  }
                  else if($table == "member_details"){
                                  $member_category = "SELECT * FROM registration";
                                                $categoryResult = mysqli_query($conn, $member_category);
                                                if ($categoryResult && mysqli_num_rows($categoryResult) > 0) {
                                                    $category = array();
                                                    while ($row = mysqli_fetch_assoc($categoryResult)) {
                                                        $category[] = $row;
                                                    }
                                                    echo json_encode($category);
                                                } else {
                                                    echo json_encode(array("message" => "No member_category found"));
                                                }
                                 }
                                 else if ($table == "member_fulldetails") {
                                     // Check if member_id is provided
                                     if (isset($_GET['member_id'])) {
                                         $member_id = mysqli_real_escape_string($conn, $_GET['member_id']);
                                         $member_details_query = "SELECT * FROM registration WHERE member_id = '$member_id'";
                                         $member_details_result = mysqli_query($conn, $member_details_query);

                                         if ($member_details_result && mysqli_num_rows($member_details_result) > 0) {
                                             $member_details = mysqli_fetch_assoc($member_details_result);
                                             echo json_encode($member_details);
                                         } else {
                                             echo json_encode(array("message" => "No member found with the provided ID"));
                                         }
                                     } else {
                                         echo json_encode(array("message" => "Member ID is required"));
                                     }
                                 }
            else if ($table == "subscription_amount") {
                if (isset($_GET['from_year']) && isset($_GET['district']) && isset($_GET['chapter']) && isset($_GET['member_type']) && isset($_GET['member_category'])) {
                    $from_year = mysqli_real_escape_string($conn, $_GET['from_year']); // Corrected variable assignment
                    $district = mysqli_real_escape_string($conn, $_GET['district']);
                    $chapter = mysqli_real_escape_string($conn, $_GET['chapter']);
                    $member_type = mysqli_real_escape_string($conn, $_GET['member_type']);
                    $member_category = mysqli_real_escape_string($conn, $_GET['member_category']);

                    $query = "SELECT subscription_amount, schedule_date, to_year FROM subscription WHERE from_year = '$from_year' AND district = '$district' AND chapter = '$chapter' AND member_type = '$member_type' AND member_category = '$member_category'";
                    $result = mysqli_query($conn, $query);

                    if ($result && mysqli_num_rows($result) > 0) {
                        $row = mysqli_fetch_assoc($result);
                        echo json_encode(array(
                            "subscription_amount" => $row['subscription_amount'],
                            "schedule_date" => $row['schedule_date'],
                            "to_year" => $row['to_year']
                        ));
                    } else {
                        echo json_encode(array("message" => "No subscription amount found"));
                    }
                } else {
                    echo json_encode(array("message" => "Invalid parameters"));
                }
            } else if ($table == "district") {
                $district = "SELECT DISTINCT district FROM subscription";
                $districtResult = mysqli_query($conn, $district);
                if ($districtResult && mysqli_num_rows($districtResult) > 0) {
                    $district = array();
                    while ($row = mysqli_fetch_assoc($districtResult)) {
                        $district[] = $row;
                    }
                    echo json_encode($district);
                } else {
                    echo json_encode(array("message" => "No subscription found"));
                }
            }

               else if ($table == "chapter") {
                                               // Check if member_id is provided
                                               if (isset($_GET['district'])) {
                                                   $district = mysqli_real_escape_string($conn, $_GET['district']);
                                                   $chapter_details_query = "SELECT DISTINCT chapter FROM subscription WHERE district = '$district'";
                                                   $chapter_details_result = mysqli_query($conn, $chapter_details_query);

                                                   if ($chapter_details_result && mysqli_num_rows($chapter_details_result) > 0) {
                                                       $chapter_details = mysqli_fetch_assoc($chapter_details_result);
                                                       echo json_encode($chapter_details);
                                                   } else {
                                                       echo json_encode(array("message" => "No member found with the provided ID"));
                                                   }
                                               } else {
                                                   echo json_encode(array("message" => "Member ID is required"));
                                               }
                                           }
                                            else if($table == "from_year")
                                            {
                                                            $district = "SELECT * FROM subscription";
                                                          $districtResult = mysqli_query($conn, $district);
                                                          if ($districtResult && mysqli_num_rows($districtResult) > 0) {
                                                              $district = array();
                                                              while ($row = mysqli_fetch_assoc($districtResult)) {
                                                                  $district[] = $row;
                                                              }
                                                              echo json_encode($district);
                                                          } else {
                                                              echo json_encode(array("message" => "No subscription found"));
                                                          }
                                                   }
}

 else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
 $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "AddSubscription") {
     // Handle the insert/update/delete actions
    $data = json_decode(file_get_contents("php://input"));

    $member_category = mysqli_real_escape_string($conn, $data->member_category);
    $from_year = mysqli_real_escape_string($conn, $data->from_year);
    $to_year = mysqli_real_escape_string($conn, $data->to_year);
    $member_type = mysqli_real_escape_string($conn, $data->member_type);
    $subscription_amount = mysqli_real_escape_string($conn, $data->subscription_amount);
    $schedule_date = mysqli_real_escape_string($conn, $data->schedule_date);
    $district = mysqli_real_escape_string($conn, $data->district);
    $chapter = mysqli_real_escape_string($conn, $data->chapter);

        $insertUserQuery = "INSERT INTO `subscription`( `member_category`, `from_year`, `to_year`, `member_type`, `subscription_amount`, `schedule_date`, `district`, `chapter`)
        VALUES ('$member_category','$from_year','$to_year','$member_type','$subscription_amount','$schedule_date','$district','$chapter')";

       $arr = [];
       $insertUserResult = mysqli_query($conn, $insertUserQuery);
       if($insertUserResult) {
          $arr["Success"] = true;
       } else {
          $arr["Success"] = false;
       }
       echo json_encode($arr);
    }
    else if ($table == "AddMember") {
              // Handle the insert/update/delete actions
             $data = json_decode(file_get_contents("php://input"));

             $member_id = mysqli_real_escape_string($conn, $data->member_id);
             $member_name = mysqli_real_escape_string($conn, $data->member_name);
             $subscribe_date = mysqli_real_escape_string($conn, $data->subscribe_date);
             $due_date = mysqli_real_escape_string($conn, $data->due_date);
             $member_type = mysqli_real_escape_string($conn, $data->member_type);
             $member_category = mysqli_real_escape_string($conn, $data->member_category);
             $subscription_amount = mysqli_real_escape_string($conn, $data->subscription_amount);

                 $insertUserQuery = "INSERT INTO `subscriber_details`( `member_id`, `member_name`, `subscribe_date`, `due_date`, `member_type`, `member_category`, `subscription_amount`)
                 VALUES ('$member_id','$member_name','$subscribe_date','$due_date','$member_type','$member_category','$subscription_amount')";

                $arr = [];
                $insertUserResult = mysqli_query($conn, $insertUserQuery);
                if($insertUserResult) {
                   $arr["Success"] = true;
                } else {
                   $arr["Success"] = false;
                }
                echo json_encode($arr);
             }
 }

 // Handle PUT request for updating data
  else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
  $table = isset($_GET['table']) ? $_GET['table'] : "";
       if ($table == "chapter") {
      // Parse JSON payload from the request
      $data = json_decode(file_get_contents("php://input"));

      // Escape and sanitize data
      $from_year = mysqli_real_escape_string($conn, $data->from_year);
      $to_year = mysqli_real_escape_string($conn, $data->to_year);
      $subscription_amount = mysqli_real_escape_string($conn, $data->subscription_amount);
      $schedule_date = mysqli_real_escape_string($conn, $data->schedule_date);
      $district = mysqli_real_escape_string($conn, $data->district);
      $chapter = mysqli_real_escape_string($conn, $data->chapter);
      $member_category = mysqli_real_escape_string($conn, $data->member_category);
      $member_type = mysqli_real_escape_string($conn, $data->member_type);
      $id = mysqli_real_escape_string($conn, $data->id);

      // Update query
      $updateQuery = "UPDATE `subscription` SET
          `from_year`='$from_year',
          `to_year`='$to_year',
          `subscription_amount`='$subscription_amount',
          `member_category`='$member_category',
          `member_type`='$member_type',
          `schedule_date`='$schedule_date',
          `district`='$district',
          `chapter`='$chapter'
          WHERE id = $id";

      header('Content-Type: application/json'); // Set header for JSON response

      if (mysqli_query($conn, $updateQuery)) {
          echo json_encode(["message" => "Record updated successfully"]);
      } else {
          echo json_encode(["error" => "Error updating record: " . mysqli_error($conn)]);
      }
  }
  else if ($table == "subscription") {
      // Parse JSON payload from the request
      $data = json_decode(file_get_contents("php://input"));

      // Escape and sanitize data
      $schedule_date = mysqli_real_escape_string($conn, $data->schedule_date);
      $due_date = mysqli_real_escape_string($conn, $data->due_date);
      $member_category = mysqli_real_escape_string($conn, $data->member_category);
      $member_type = mysqli_real_escape_string($conn, $data->member_type);
      $id = mysqli_real_escape_string($conn, $data->id);

      // Update query
      $updateQuery = "UPDATE `registration` SET
          `member_category`='$member_category',
          `member_type`='$member_type',
          `schedule_date`='$schedule_date',
          `due_date`='$due_date'
          WHERE id = $id";

      if (mysqli_query($conn, $updateQuery)) {
          echo json_encode(["message" => "Record updated successfully"]);
      } else {
          echo json_encode(["error" => "Error updating record: " . mysqli_error($conn)]);
      }
  }
}


  else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
      $id = isset($_GET['id']) ? $_GET['id'] : null;

      if (!$id) {
          echo json_encode(array("error" => "ID is missing in the request"));
          exit;
      }

      $id = mysqli_real_escape_string($conn, $id);

      $sql = "DELETE FROM subscription WHERE id = '$id'";
      $result = $conn->query($sql);

      if ($result === false) {
          echo json_encode(array("error" => "Query failed: " . $conn->error));
      } else {
          echo json_encode(array("message" => "Member Type deleted successfully"));
      }
  }

 mysqli_close($conn);
 ?>