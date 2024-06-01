<?php
include 'connection.php';  // Ensure you include your database connection

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

/**
 * Establish and return a database connection.
 *
 * @return mysqli
 */
function getDbConnection() {


    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}

/**
 * Fetch registration data based on provided filters.
 *
 * @param string $chapter
 * @param string $district
 * @param string $team_name
 * @return array
 */
function fetchRegistrationData($chapter, $district, $team_name) {
    $conn = getDbConnection();
    $sql = "SELECT mobile, first_name, member_type, team_name, member_id FROM registration WHERE team_name != ''";
    $types = '';
    $params = [];

    // Add filters if provided
    if (!empty($chapter)) {
        $sql .= " AND chapter = ?";
        $types .= 's';
        $params[] = $chapter;
    }
    if (!empty($district)) {
        $sql .= " AND district = ?";
        $types .= 's';
        $params[] = $district;
    }
    if (!empty($team_name)) {
        $sql .= " AND team_name = ?";
        $types .= 's';
        $params[] = $team_name;
    }

    $stmt = $conn->prepare($sql);

    if ($types) {
        $stmt->bind_param($types, ...$params);
    }

    $stmt->execute();
    $result = $stmt->get_result();

    $data = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }

    $stmt->close();
    $conn->close();

    return $data;
}

/**
 * Output data as JSON.
 *
 * @param array $data
 */
function outputJson($data) {
    header('Content-Type: application/json');
    echo json_encode($data);
}

/**
 * Get input parameters from GET request.
 *
 * @param string $param
 * @return string
 */
function getInput($param) {
    return isset($_GET[$param]) ? $_GET[$param] : '';
}


function handleGetRequest() {
    $chapter = getInput('chapter');
    $district = getInput('district');
    $team_name = getInput('team_name');

    $data = fetchRegistrationData($chapter, $district, $team_name);
    outputJson($data);
}


function handlePostRequest() {
    // Implement the logic to handle POST requests
    // Example: Inserting new registration data
}

/**
 * Handle PUT request.
 */
function handlePutRequest() {
    // Implement the logic to handle PUT requests
    // Example: Updating existing registration data
}

/**
 * Handle DELETE request.
 */
function handleDeleteRequest() {
    // Implement the logic to handle DELETE requests
    // Example: Deleting registration data
}

/**
 * Main request handler.
 */
function handleRequest() {
    switch ($_SERVER['REQUEST_METHOD']) {
        case 'GET':
            handleGetRequest();
            break;
        case 'POST':
            handlePostRequest();
            break;
        case 'PUT':
            handlePutRequest();
            break;
        case 'DELETE':
            handleDeleteRequest();
            break;
        default:
            header('HTTP/1.1 405 Method Not Allowed');
            echo json_encode(['error' => 'Method not allowed']);
            break;
    }
}


// Main execution
handleRequest();
?>
