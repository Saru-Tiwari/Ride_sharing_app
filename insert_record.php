<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

include("dbconnection.php");
$con = dbconnection();

// Check if all required POST data is set
if (!isset($_POST["name"]) || !isset($_POST["email"]) || !isset($_POST["password"]) || !isset($_POST["phnum"])) {
    echo json_encode(["success" => "false", "message" => "Missing required fields"]);
    exit();
}

// Escape input to prevent SQL injection
$name = mysqli_real_escape_string($con, $_POST["name"]);
$email = mysqli_real_escape_string($con, $_POST["email"]);
$password = mysqli_real_escape_string($con, $_POST["password"]);
$phnum = mysqli_real_escape_string($con, $_POST["phnum"]);

// Hash the password securely
$hashedPassword = password_hash($password, PASSWORD_DEFAULT); // Hashing the password

// SQL query to insert the data with the hashed password
$query = "INSERT INTO `user_table` (`name`, `email`, `password`, `phnum`) 
          VALUES ('$name', '$email', '$hashedPassword', '$phnum')";
$exe = mysqli_query($con, $query);

// Prepare and return the JSON response
$response = [];
if ($exe) {
    $response["success"] = "true";
    $response["message"] = "Record inserted successfully";
} else {
    $response["success"] = "false";
    $response["message"] = "Failed to insert record";
    $response["error"] = mysqli_error($con); // Include error details for debugging
}

// Ensure proper JSON output
header('Content-Type: application/json');
echo json_encode($response);
?>