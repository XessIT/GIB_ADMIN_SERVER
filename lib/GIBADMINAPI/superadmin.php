<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'connection.php';  // Ensure you include your database connection

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    handleGetRequest($conn);
} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    handlePostRequest($conn);
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    handlePutRequest($conn);
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    handleDeleteRequest($conn);
}

mysqli_close($conn);

function handleGetRequest($conn) {
    $sql = "SELECT mobile, first_name, last_name, role, member_id, company_name, admin_access FROM registration WHERE role != ''";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        die("Error preparing statement: " . $conn->error);
    }

    // No need to bind parameters as there are none in the query

    if (!$stmt->execute()) {
        die("Error executing query: " . $stmt->error);
    }

    $result = $stmt->get_result();

    $members = array();

    while ($row = $result->fetch_assoc()) {
        $members[] = $row;
    }

    $stmt->close();

    if (empty($members)) {
        die("Error: No data found.");
    }

    echo json_encode($members);
}

function handlePostRequest($conn) {
    // Handle POST logic here
}

function handlePutRequest($conn) {
    $input_data = json_decode(file_get_contents('php://input'), true);

    if (!isset($input_data['member_id'])) {
        die("Error: Member ID parameter is required.");
    }

    $member_id = $input_data['member_id'];
    $action = $input_data['action']; // New parameter for action (update/remove)

    if ($action === 'update') {
        // Update admin_access for the specified member
        $sql = "UPDATE registration SET admin_access = 'Yes' WHERE member_id = ?";
    } else if ($action === 'remove') {
        // Remove admin_access for the specified member
        $sql = "UPDATE registration SET admin_access = 'No' WHERE member_id = ?";
    } else {
        die("Error: Invalid action specified.");
    }

    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        die("Error preparing statement: " . $conn->error);
    }

    $stmt->bind_param('i', $member_id); // Assuming member_id is an integer
    if (!$stmt->execute()) {
        die("Error executing query: " . $stmt->error);
    }

    $stmt->close();

    echo json_encode(array('message' => 'Admin access updated successfully.'));
}



function handleDeleteRequest($conn) {
    // Handle DELETE logic here
}
?>
