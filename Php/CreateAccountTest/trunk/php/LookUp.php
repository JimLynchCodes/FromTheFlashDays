<?php
function check_input($value)
{
// Stripslashes
if (get_magic_quotes_gpc())
  {
  $value = stripslashes($value);
  }
// Quote if not a number
if (!is_numeric($value))
  {
  $value = "'" . mysql_real_escape_string($value) . "'";
  }
return $value;
}

function lookItUp($username, $password)
{
	
$con = mysql_connect("newer.cwglba5cwihw.us-east-1.rds.amazonaws.com/UserInfo", "bob", "james123");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

$user = $username;
$pwd = $password;
// Make a safe SQL
$user = check_input($_POST['user']);
$pwd = check_input($_POST['pwd']);
$sql = "SELECT * FROM users WHERE
user=$user AND password=$pwd";

return mysql_query($sql);

mysql_close($con);

}
?> 