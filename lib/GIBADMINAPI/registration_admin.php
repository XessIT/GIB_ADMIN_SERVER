 <?php
 header("Access-Control-Allow-Origin: *");
 header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
 header("Access-Control-Allow-Headers: Content-Type, Authorization");

 include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
   $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "district") {
            $offerlist = "SELECT DISTINCT district FROM district";
            $offerResult = mysqli_query($conn, $offerlist);
            if ($offerResult && mysqli_num_rows($offerResult) > 0) {
                $offers = array();
                while ($row = mysqli_fetch_assoc($offerResult)) {
                    $offers[] = $row;
                }
                echo json_encode($offers);
            } else {
                echo json_encode(array("message" => "No offers found"));
            }
    }elseif($table == "chapter"){
        $district = isset($_GET['district']) ? mysqli_real_escape_string($conn, $_GET['district']) : "";

            $offerlist = "SELECT chapter FROM chapter WHERE district = '$district' ORDER BY chapter";
                 $offerResult = mysqli_query($conn, $offerlist);
                 if ($offerResult && mysqli_num_rows($offerResult) > 0) {
                     $offers = array();
                     while ($row = mysqli_fetch_assoc($offerResult)) {
                         $offers[] = $row;
                     }
                     echo json_encode($offers);
                 } else {
                     echo json_encode(array("message" => "No offers found"));
                 }

    }
     elseif ($table == "registration") {

    $id = isset($_GET['id']) ? mysqli_real_escape_string($conn, $_GET['id']) : "";
    $mobile = isset($_GET['mobile']) ? mysqli_real_escape_string($conn, $_GET['mobile']) : "";
    $member_id = isset($_GET['member_id']) ? mysqli_real_escape_string($conn, $_GET['member_id']) : "";
    $block_status = isset($_GET['block_status']) ? mysqli_real_escape_string($conn, $_GET['block_status']) : "";
    $member_type = isset($_GET['member_type']) ? mysqli_real_escape_string($conn, $_GET['member_type']) : "";
                 // Fetch data from the registration table
                         if(isset($_GET['id'])){

                        $registrationlist = "SELECT * FROM registration where id='$id'";

                        }else if(isset($_GET["mobile"])){

                          $registrationlist = "SELECT * FROM registration where mobile='$mobile'";

                        }else if(isset($_GET["member_id"])){

                          $registrationlist = "SELECT mobile FROM registration where member_id='$member_id'";

                        }
                        else if(isset($_GET["block_status"])){

                        $registrationlist = "SELECT * FROM registration where block_status='$block_status' AND admin_rights = 'Accepted'";

                        }
                        else if(isset($_GET["member_type"])){

                        $registrationlist = "SELECT * FROM registration where member_type='$member_type'";

                       }
                        else{
                        $registrationlist = "SELECT * FROM registration";

                       // echo "Invalid parameter";
                        }
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
             } else {
                       echo json_encode(array("message" => "Invalid table name"));
                       exit;
           }

}
else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

        $id = mysqli_real_escape_string($conn, $data->id);
        $block_status = mysqli_real_escape_string($conn, $data->block_status);

        $updateBlockStatusQuery = "UPDATE `registration` SET `block_status`='$block_status' WHERE `id`='$id'";
        $updateBlockStatusResult = mysqli_query($conn, $updateBlockStatusQuery);

        if ($updateBlockStatusResult) {
            echo "registration blocked/unblocked successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }

}



mysqli_close($conn);
?>