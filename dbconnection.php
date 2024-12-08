<?php
function dbconnection()
{
    $con=mysqli_connect("localhost","root","","profiles");
    return $con;
}

?>