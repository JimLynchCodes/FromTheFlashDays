<?php

class QuestionDbUtil2
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
	
  public function getStringVar($userInfoAry)
  {
	  $varToGet = $userInfoAry[0];
	  $name = $userInfoAry[1];
	  
	  $query = $this->connection->query("SELECT pword FROM users WHERE name='$name';");
	
	
	
	
	if ($result = $query->fetch_object())
	{
		return $result->password;
		echo "is {$result->password} years old."; 
	}
	
	 
  }
  
    
  public function addAWin($ary)
  {
	  $name = $ary[0];
	 	  
    $sql = "UPDATE users SET wins='10' WHERE name='$name';";
    
	if ($this->connection->query($sql))
	{
		return true;
	}
	else
	{
		
    return false;
	}
  }
  

  
  
  public function easyUpdate($nameo)
{
	
	$name = $nameo;
	
	$sql = "Update users SET pword='hey' WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}


  public function updateWins($nameo)
{
	
	$name = $nameo;
	
	$sql = "Update users SET wins=(wins+'1') WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}

  public function addToLevel($ary)
{
	
	$name = $ary[0];
	$level = $ary[1];
	
	$sql = "Update users SET level=(level+'$level') WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}


public function lookupExp($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT exp FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->exp;
		echo "$name is {$result->exp} years old.";  
	}
	else
	{
		return false;
	}
	  
}

public function lookupWins($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT wins FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->exp;
		echo "$name is {$result->exp} years old.";  
	}
	else
	{
		return false;
	}
	  
}
  
  
  public function lookupLevel($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT level FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->exp;
		echo "$name is {$result->exp} years old.";  
	}
	else
	{
		return false;
	}
	  
}
	
	
	 public function getSomething()
  {
    $sql = "INSERT INTO users (email, name, pword) VALUES ('billybob', 'san','fran');";
    $result = $this->connection->query($sql);
    
    if ($result == false)
    {
    //  trigger_error("Error - problem with getting your data.");
    }

    return $result;  
  }
	
	
	
	
	
	
	
	public function talk_back($value)
	{
		return "You said " . $value;
	}
	
}

?>