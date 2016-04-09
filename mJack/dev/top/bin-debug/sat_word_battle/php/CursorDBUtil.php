<?php

class CursorDBUtil
{
	
	protected $connection;
  
  public function __construct()
  {
    $this->connection = new mysqli("userinfo.cwglba5cwihw.us-east-1.rds.amazonaws.com", "amf", "jam12345", "UserInfo");
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
  
  
  public function checkIfItemOwned($username, $databaseVar)
{

	$query = $this->connection->query("SELECT `$databaseVar` FROM items WHERE name='$username';");
	
	if ($result = $query->fetch_object())
	{
		
		return $result->$databaseVar;
		//echo "$name is {$result->name} years old.";  
	}
	else
	{
		return false;
	}
	  
}


  public function getCurrentCursor($username)
{

	$query = $this->connection->query("SELECT currentItemClass FROM items WHERE name='$username';");
	
	if ($result = $query->fetch_object())
	{
		return $result->currentItemClass;
		//echo "$name is {$result->name} years old.";  
	}
	else
	{
		return false;
	}
	  
}

 public function updateCurrentCursor($username, $cursorClassName)
{

	$sql = "UPDATE items SET currentItemClass = '$cursorClassName' WHERE name='$username';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}


  public function getOffset($username)
{

	$query = $this->connection->query("SELECT offsetX, offsetY FROM items WHERE name='$username';");
	
	if ($result = $query->fetch_object())
	{
		$returnAry = array(`currentItemClass`, `name`);
		
		return array($result->offsetX, $result->offsetY);
		//echo "$name is {$result->name} years old.";  
	}
	else
	{
		return false;
	}
	  
}

 public function updateCursorOffset($username, $offsetX, $offsetY)
{

	$sql = "UPDATE items SET offsetX = '$offsetX', offsetY = '$offsetY' WHERE name='$username';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}


  public function unlockItem($username, $databaseVar)
{

	$sql =  "UPDATE items SET `$databaseVar`='1' WHERE name='$username';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}

  
}