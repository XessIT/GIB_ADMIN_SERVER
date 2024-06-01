<?php
error_log($_SERVER['REQUEST_METHOD']);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $table = isset($_GET['table']) ? $_GET['table'] : "";
    switch ($table) {
        case "offers":
            $offerlist = "SELECT * FROM offers";
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
            break;
        case "registration":
            $registrationlist = "SELECT * FROM registration";
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
            break;
        case "ads":
            $adslist = "SELECT * FROM ads";
            $adsResult = mysqli_query($conn, $adslist);
            if ($adsResult && mysqli_num_rows($adsResult) > 0) {
                $ads = array();
                while ($row = mysqli_fetch_assoc($adsResult)) {
                    $ads[] = $row;
                }
                echo json_encode($ads);
            } else {
                echo json_encode(array("message" => "No ads found"));
            }
            break;
        default:
            echo json_encode(array("message" => "Invalid table name"));
            break;
    }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    // Validate input fields
    if (!isset($data->imagename) || !isset($data->imagedata) || !isset($data->member_name) || !isset($data->member_id) || !isset($data->from_date) || !isset($data->to_date) || !isset($data->price) || !isset($data->selected_member_types)) {
        echo json_encode(array("error" => "Incomplete data"));
        exit;
    }

    // Sanitize input data
    $imagename = is_array($data->imagename) ? $data->imagename : array($data->imagename);
    $imagedata = is_array($data->imagedata) ? $data->imagedata : array($data->imagedata);

    $member_name = mysqli_real_escape_string($conn, $data->member_name);
    $member_id = mysqli_real_escape_string($conn, $data->member_id);
    $from_date = mysqli_real_escape_string($conn, $data->from_date);
    $to_date = mysqli_real_escape_string($conn, $data->to_date);
    $price = mysqli_real_escape_string($conn, $data->price);
    $selected_member_types = mysqli_real_escape_string($conn, $data->selected_member_types); // Added member_type

    $imagePaths = array();
    for ($i = 0; $i < count($imagename); $i++) {
        $name = mysqli_real_escape_string($conn, $imagename[$i]);
        $data = mysqli_real_escape_string($conn, $imagedata[$i]);
        $path = "ads_image/$name";
        if (file_put_contents($path, base64_decode($data))) {
            $imagePaths[] = $path;
        } else {
            echo json_encode(array("error" => "Failed to save image: $name"));
            exit;
        }
    }

    $imagePathsStr = implode(",", $imagePaths);

    // Convert selected_member_types to text format
    $memberTypeText = '';
    if (strpos($selected_member_types, 'Executive') !== false) {
        $memberTypeText .= 'Executive,';
    }
    if (strpos($selected_member_types, 'NonExecutive') !== false) {
        $memberTypeText .= 'NonExecutive,';
    }
    // Remove trailing comma if exists
    $memberTypeText = rtrim($memberTypeText, ',');

    // Insert data into database with member_type included
    $insertUserQuery = "INSERT INTO `ads`(`member_name`, `member_id`, `from_date`, `to_date`, `price`, `ads_image`, `member_type`) VALUES ('$member_name','$member_id','$from_date','$to_date','$price', '$imagePathsStr', '$memberTypeText')";

    $insertUserResult = mysqli_query($conn, $insertUserQuery);
    if ($insertUserResult) {
        echo json_encode(array("Success" => true));
    } else {
        echo json_encode(array("Success" => false, "error" => mysqli_error($conn)));
    }
}

 elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

    // Check if block_status is provided
    if (isset($data->block_status)) {
        $ID = mysqli_real_escape_string($conn, $data->ID);
        $block_status = mysqli_real_escape_string($conn, $data->block_status);

        $updateBlockStatusQuery = "UPDATE `offers` SET `block_status`='$block_status' WHERE `ID`='$ID'";
        $updateBlockStatusResult = mysqli_query($conn, $updateBlockStatusQuery);

        if ($updateBlockStatusResult) {
            echo "Offer blocked/unblocked successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }
    } else {
        // Handle the insert/update actions for editing an offer
        $name = mysqli_real_escape_string($conn, $data->name);
        $discount = mysqli_real_escape_string($conn, $data->discount);
        $ID = mysqli_real_escape_string($conn, $data->ID);
        $offer_type = mysqli_real_escape_string($conn, $data->offer_type);
        $validity = mysqli_real_escape_string($conn, $data->validity);

        $updateOfferQuery = "UPDATE `offers` SET `offer_type`='$offer_type', `name`='$name', `discount`='$discount', `validity`='$validity' WHERE `ID`='$ID'";
        $updateOfferResult = mysqli_query($conn, $updateOfferQuery);

        if ($updateOfferResult) {
            echo "Offer updated successfully";
        } else {
            echo "Error: " . mysqli_error($conn);
        }
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $ID = isset($_GET['ID']) ? $_GET['ID'] : null;

    if (!$ID) {
        echo json_encode(array("error" => "ID is missing in the request"));
        exit;
    }

    $ID = mysqli_real_escape_string($conn, $ID);

    $sql = "DELETE FROM offers WHERE ID = '$ID'";
    $result = mysqli_query($conn, $sql);

    if ($result === false) {
        echo json_encode(array("error" => "Query failed: " . mysqli_error($conn)));
    } else {
        echo json_encode(array("message" => "Offer deleted successfully"));
    }
}

mysqli_close($conn);
?>
