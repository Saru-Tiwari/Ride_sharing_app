<?php
$query = "SELECT `password` FROM `user_table` WHERE `email` = '$email'";
$result = mysqli_query($con, $query);
if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $hashedPassword = $row['password'];

    if (password_verify($password, $hashedPassword)) {
        echo json_encode(["success" => "true", "message" => "Login successful"]);
    } else {
        echo json_encode(["success" => "false", "message" => "Invalid password"]);
    }
} else {
    echo json_encode(["success" => "false", "message" => "User not found"]);
}
?>
