<?php

class TalkBack
{
//	private $theConnection;
	
//	public function __construct()
//	{
//		$theConnection = mysql_connect("thisdb.cwglba5cwihw.us-east-1.rds.amazonaws.com", "bob", "jam12345");
//		mysql_select_db("UserInfo", $theConnection);
	
//	}
// bob

//class GetData
//{
  protected $connection;
  
  public function __construct()
  {
    $this->connection = new mysqli("thisdb.cwglba5cwihw.us-east-1.rds.amazonaws.com", "bob", "jam12345", "UserInfo");
    $this->connection->query("SET NAMES utf8");
    $this->connection->query("SET CHARACTER_SET utf8_unicode_ci");
    
    if (mysqli_connect_errno())
    {
      trigger_error("Error - problem with connecting to database: ". mysqli_connect_error());    
    }
  }

  public function getSomething()
  {
    $sql = "INSERT INTO new_table (name, pword) VALUES ('san','fran');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
    //  trigger_error("Error - problem with getting your data.");
    }

    return $result;  
  }
  
  public function insertNice($things)
  {
    $sql = "INSERT INTO new_table (name, pword) VALUES ('$things[0]', '$things[1]');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
      //trigger_error("Error - problem with getting your data.");
    }
	
    return $result;  
  }
  
   public function updateEasy()
  {
    $sql = "UPDATE new_table SET name='niggr' WHERE pword='fuck';";
    
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
  
  
  
 // public function easyLookup()
 // {
	//$name = sanlo;
//	$query = $sql->query("SELECT pword FROM new_table WHERE name='sanlo';");
	
//	if ($result = $query->fetch_object())
//	{
//		return true;
//		echo "$name is {$result->pword} years old.";  
//	}
//	else
//	{
//		return false;
//	}
	
	
	  
 // }
  
  
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