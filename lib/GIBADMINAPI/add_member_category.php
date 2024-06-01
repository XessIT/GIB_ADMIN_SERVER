<?php
error_log($_SERVER['REQUEST_METHOD']);
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $table = isset($_GET['table']) ? $_GET['table'] : "";
    if ($table == "withoutFilter") {
        $memberCategoryname = "SELECT * FROM member_category";
        $memberCategoryResult = mysqli_query($conn, $memberCategoryname);
        if ($memberCategoryResult && mysqli_num_rows($memberCategoryResult) > 0) {
            $category = array();
            while ($row = mysqli_fetch_assoc($memberCategoryResult)) {
                $category[] = $row;
            }
            echo json_encode($category);
        } else {
            echo json_encode(array("message" => "No meeting found"));
        }
    } if ($table == "withFilter") {
          if (isset($_GET['member_type']) && isset($_GET['chapter']) && isset($_GET['district'])) {
              $district = mysqli_real_escape_string($conn, $_GET['district']);
              $chapter = mysqli_real_escape_string($conn, $_GET['chapter']);
              $member_type = mysqli_real_escape_string($conn, $_GET['member_type']);
              $from_year = mysqli_real_escape_string($conn, $_GET['from_year']);
              $to_year = mysqli_real_escape_string($conn, $_GET['to_year']);

              $userlist = "
                  SELECT mc.* FROM member_category mc
                  LEFT JOIN subscription s ON mc.member_category = s.member_category
                      AND s.from_year <= '$to_year'
                      AND s.to_year >= '$from_year'
                      AND s.district >= '$district'
                      AND s.chapter >= '$chapter'
                      AND s.member_type >= '$member_type'
                  WHERE mc.district = '$district'
                    AND mc.chapter = '$chapter'
                    AND mc.member_type = '$member_type'
                    AND s.member_category IS NULL";
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



}
else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle the insert/update/delete actions
    $data = json_decode(file_get_contents("php://input"));

    $member_category = mysqli_real_escape_string($conn, $data->member_category);
    $member_type = mysqli_real_escape_string($conn, $data->member_type);
    $district = mysqli_real_escape_string($conn, $data->district);
    $chapter = mysqli_real_escape_string($conn, $data->chapter);

    $insertUserQuery = "INSERT INTO member_category (member_category, member_type, district, chapter)
                        VALUES ('$member_category', '$member_type', '$district', '$chapter')";

    $arr = [];
    $insertUserResult = mysqli_query($conn, $insertUserQuery);
    if ($insertUserResult) {
        $arr["Success"] = true;
    } else {
        $arr["Success"] = false;
    }
    echo json_encode($arr);
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Parse JSON payload from the request
    $data = json_decode(file_get_contents("php://input"));

    // Escape and sanitize data
    $member_category = mysqli_real_escape_string($conn, $data->member_category);
    $id = mysqli_real_escape_string($conn, $data->id);

    // Update query
    $updateQuery = "UPDATE member_category SET member_category = '$member_category' WHERE id = $id";
    if (mysqli_query($conn, $updateQuery)) {
        echo "Record updated successfully";
    } else {
        echo "Error updating record: " . mysqli_error($conn);
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
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
} else {
    echo json_encode(array("message" => "Unsupported request method"));
}

mysqli_close($conn);
?>
