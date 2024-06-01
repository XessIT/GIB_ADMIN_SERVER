<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gib";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!isset($_GET['mobile']) || !isset($_GET['password'])) {
        die(json_encode(["error" => "Mobile and password parameters are required"]));
    }

    // Get data from Flutter app
    $mobile = mysqli_real_escape_string($conn, $_GET['mobile']);
    $password = mysqli_real_escape_string($conn, $_GET['password']);

    // Check if the user exists in the database with the provided mobile and password
    $signInQuery = "SELECT * FROM registration WHERE mobile = '$mobile' AND password = '$password' AND type = 'Admin'";
    $signInResult = mysqli_query($conn, $signInQuery);
    if ($signInResult) {
        if (mysqli_num_rows($signInResult) > 0) {
            $userData = mysqli_fetch_assoc($signInResult);

            if ($userData['admin_rights'] == 'Accepted' && $userData['block_status'] == 'UnBlock') {
                echo json_encode([
                    "status" => "Authentication successful",
                    "type" => $userData['type']
                ]);
            } elseif ($userData['admin_rights'] == 'Rejected') {
                echo json_encode(["error" => "You are not accepted"]);
            } elseif ($userData['block_status'] == 'Blocked') {
                echo json_encode(["error" => "You are blocked"]);
            } else {
                echo json_encode(["error" => "Invalid conditions for login"]);
            }
        } else {
            echo json_encode(["error" => "Invalid username or password"]);
        }
    } else {
        echo json_encode(["error" => "Error: " . mysqli_error($conn)]);
    }
}

mysqli_close($conn);
?>
