<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  $mobile = isset($_GET['mobile']) ? mysqli_real_escape_string($conn, $_GET['mobile']) : "";
  $password = isset($_GET['password']) ? mysqli_real_escape_string($conn, $_GET['password']) : "";

  if (!empty($mobile) && !empty($password)) {
    $registrationlist = "SELECT * FROM registration WHERE admin_access = 'Yes' AND mobile='$mobile'";
    $registrationResult = mysqli_query($conn, $registrationlist);

    if ($registrationResult && mysqli_num_rows($registrationResult) > 0) {
      // Mobile number exists with admin access
      $row = mysqli_fetch_assoc($registrationResult);
      if ($row['password'] == $password) {
        echo json_encode(array("success" => "Login successful", "mobile" => $row['mobile']));
      } else {
        echo json_encode(array("error" => "Incorrect password"));
      }
    } else {
      echo json_encode(array("error" => "Authorized Persons Only"));
    }
  } else {
    echo json_encode(array("error" => "Mobile number or password is empty"));
  }
} else {
  echo json_encode(array("error" => "Invalid request method"));
}

mysqli_close($conn);
?>
