<?php
include("dbconnection.php");
$con = dbconnection();

if (isset($_GET['email'])) {
    $email = mysqli_real_escape_string($con, $_GET['email']);

    // Query to fetch user data based on email
    $query = "SELECT name, email, phnum FROM user_table WHERE email = '$email'";
    $result = mysqli_query($con, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        echo json_encode([
            "success" => true,
            "name" => $row['name'],
            "email" => $row['email'],
            "phone" => $row['phnum']
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "User not found"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Email parameter missing"
    ]);
}
?>
