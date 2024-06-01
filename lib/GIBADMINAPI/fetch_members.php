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
    if (!isset($_GET['district']) || !isset($_GET['chapter'])) {
        die("Error: District and chapter parameters are required.");
    }

    $district = $_GET['district'];
    $chapter = $_GET['chapter'];

    $sql = "SELECT id, first_name, mobile, member_type, FALSE as isChecked
            FROM registration
            WHERE district = ?
                AND chapter = ?
                AND (member_type = 'Executive' OR member_type = 'Non-Executive')
                AND (team_name IS NULL OR team_name = '')";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        die("Error preparing statement: " . $conn->error);
    }

    $stmt->bind_param("ss", $district, $chapter);

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

    if (!isset($input_data['members']) || !isset($input_data['team_name'])) {
        die("Error: Members and team_name parameters are required.");
    }

    $members = $input_data['members'];
    $team_name = $input_data['team_name'];

    // Update team_name for selected members
    if (count($members) > 0) { // Check if there are selected members
        $sql = "UPDATE registration SET team_name = ? WHERE id IN (";

        // Dynamically create the placeholders for member IDs
        $placeholders = implode(',', array_fill(0, count($members), '?'));
        $sql .= $placeholders . ")";

        $stmt = $conn->prepare($sql);

        if (!$stmt) {
            die("Error preparing statement: " . $conn->error);
        }

        // Bind parameters for the team_name and member IDs
        $bind_params = array_merge(array($team_name), $members);
        $bind_types = 's' . str_repeat('i', count($members)); // 's' for string (team_name), 'i' for integers (member IDs)
        $stmt->bind_param($bind_types, ...$bind_params);

        if (!$stmt->execute()) {
            die("Error executing query: " . $stmt->error);
        }

        $stmt->close();

        echo json_encode(array('message' => 'Team name updated successfully.'));
    } else {
        die("Error: No members selected.");
    }
}



function handleDeleteRequest($conn) {
    // Handle DELETE logic here
}
?>
