<?php

class TalkBack
{
//	private $theConnection;
	
//	public function __construct()
//	{
//		$theConnection = mysql_connect("thisdb.cwglba5cwihw.us-east-1.rds.amazonaws.com", "bob", "jam12345");
//		mysql_select_db("UserInfo", $theConnection);
	
//	}


//class GetData
//{
  protected $connection;
  
  public function __construct()
  {
    $this->connection = new mysqli("userinfo.cwglba5cwihw.us-east-1.rds.amazonaws.com", "bob", "jam123456", "UserInfo");
    $this->connection->query("SET NAMES utf8");
    $this->connection->query("SET CHARACTER_SET utf8_unicode_ci");
    
    if (mysqli_connect_errno())
    {
      trigger_error("Error - problem with connecting to database: ". mysqli_connect_error());    
    }
	else
	{
		return 'connection successful';	
	}
	
	
  }

  public function getSomething()
  {
    $sql = "INSERT INTO users (rank, name, pword) VALUES (1, 'san','fran');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
    //  trigger_error("Error - problem with getting your data.");
    }

    return $result;  
  }
  
  public function signIn($userInfoAry)
  {
	 $name = $userInfoAry[0];
//	$password = $userInfoAry[1]; 
	
	 $sql = "SELECT * FROM NewTableMan WHERE name = '$name'";
	 
	 // Escape Query
	//$sql = $mysqli->real_escape_string($sql);


 	if ( $result = $this->connection->query($sql))
	{
		 // Cycle through results
	//   while($row = $this->connection->fetch_object($result)){
	  // echo $row->column;
	}
    
	// Create Query
//	$query = "SELECT * FROM table";
	 
	

	// Execute Query
//if($result = $mysqli->query($query)){
	  
	 // Cycle through results
//19	 while($row = $mysqli->fetch_object($result)){
//20	   echo $row->column;
//21	 }
	 
	
	
//    if ($result == false)
//    {
    
//	return 'didnt work';
//    }

//    else
//    {
//      return $result; 
//    }
 
  
	}
	
  public function insertNewPerson($userInfoAry)
  {
	$name = $userInfoAry[0];
	$password = $userInfoAry[1];
	$id = $userInfoAry[2];  
	  
	 $sql = "INSERT INTO NewTableMan (idNewTableMan, name, password) VALUES ('$id','$name','$password');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
    //  trigger_error("Error - problem with getting your data.");
    }

    return $result; 
	  
  }
  
  
  
   public function insertNewPersonAutoInc($userInfoAry)
  {
	$name = $userInfoAry[0];
	$password = $userInfoAry[1];
	$id = $userInfoAry[2];
	  
	 $sql = "INSERT INTO NewTableMan (name, password, idNewTableMan) VALUES ('$name', '$password', '$id');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
    //  trigger_error("Error - problem with getting your data.");
    }

    return $result; 
	  
  }
  
  
  
  public function insertNice($things)
  {
    $sql = "INSERT INTO devrds.NewTableMan (name, pword) VALUES ('$things[0]', '$things[1]');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
      //trigger_error("Error - problem with getting your data.");
	  return "error somewhere connecting";
    }
	
    return "done";  
  }
  
  
    
   public function updateEasy($ary)
  {
	  $newPass = $ary[0];
	  
    $sql = "UPDATE NewTableMan SET name='$newPass' WHERE password='fuck';";
    
	if ($this->connection->query($sql))
	{
		return true;
	}
	else
	{
		
    return false;
	}
  }
  
//
  
//	  return $this->database->query("SELECT name FROM new_table WHERE pword = fuck"); 
	  
//    $sql = "SELECT 'name' FROM new_table";
 //   $result = $this->connection->query($sql);
    
//    if ($result == false)
//    {
//      trigger_error("Error - problem with getting your data.");
//    }

//    return $result;  
  
  
  
//  public function updateEasyBoy()
//  {
	
//	$query = "UPDATE new_table SET pword='joey' WHERE name='sanlo'";

//if ($result = $this->connection->query($query)) {
///	return true;
//}
//else
//{
//	return false;
//}
    /* fetch object array */
 //   while ($row = $result->fetch_row()) {
     //   printf ("%s (%s)\n", $row[0], $row[1]);
//	 	return $row[0];
 //   }

    /* free result set */
   //  $result->close();
//}  
  
  
  
public function easyLookup($ary)
{
	
	$name = $ary[0];
	
	$query = $this->connection->query("SELECT password FROM NewTableMan WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->password;
		echo "$name is {$result->password} years old.";  
	}
	else
	{
		return false;
	}
	  
}
  
  
 public function easyDoubleLookup($ary)
{
	
	$name = $ary[0];
	$password = $ary[1];
	
	$query = $this->connection->query("SELECT password FROM NewTableMan WHERE name='$name' && password = '$password';");
	
	if ($result = $query->fetch_object())
	{
		return true;
		//return $result->password;
		echo "$name is {$result->password} years old.";  
	}
	else
	{
		return false;
	}
	  
} 
  
  
//   public function selectPasswordFromName($name)
//  {
//	* ok so we've connected, let's write our query, 
//we'll set a variable called name */
// $name = 'Mike';
// $query = $sql->query("SELECT `age` FROM `people` WHERE `name` = '$name'");
// $result = $query->fetch_object();
// echo "$name is {$result->age} years old.";
	
	
 //   $sql = "SELECT 'pword' FROM 'new_table' WHERE 'name' = '$name' LIMIT 1";
 //   $queryResult = $this->connection->query($sql);
//    $result = $queryResult->fetch_object();
	
 //   if ($result == false)
 //   {
 //     trigger_error("Error - problem with getting your data.");
 //   }
	
 //   return $result;  
  //}
  
  
 // public function __destruct()
  //{
   // $this->mysqli->close();
  //}


	public function talk_back($value)
	{
		return "You said " . $value;
	}
	
	
	public function putTogether($params)
	{
		return "You said " . $params[0] . " and " . $params[1];
	}
	
	
	
}

?>