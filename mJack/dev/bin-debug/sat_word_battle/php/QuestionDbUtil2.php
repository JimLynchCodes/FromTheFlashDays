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


  public function addOneWin($nameo)
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

  public function addOneLevel($nameo)
{
	
	$name = $nameo;
	
	$sql = "Update users SET level=(level+'1') WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}


  public function addToExp($name, $delta)
{
	
	$sql = "Update users SET exp=(exp+'$delta') WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}




public function subtractAmountFromCoins($name, $delta)
{
	
	$sql = "Update users SET coins=(coins-'$delta') WHERE name='$name';";
	
	if ($this->connection->query($sql))
	{
		return true;

	}
	else
	{
		return false;
	}
	  
}

public function addToCoins($name, $delta)
{
	
	$sql = "Update users SET coins=(coins+'$delta') WHERE name='$name';";
	
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
		return $result->wins;
		echo "$name is {$result->wins} years old.";  
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
		return $result->level;
		echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	  
}

  public function lookupCoins($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT coins FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->coins;
		echo "$name is {$result->coins} years old.";  
	}
	else
	{
		return false;
	}
	  
}

public function getNameFromEmail($emailo)
{
	
	$email = $emailo;
	
	$query = $this->connection->query("SELECT name FROM users WHERE email='$email';");
	
	if ($result = $query->fetch_object())
	{
		return $result->name;
		//echo "$name is {$result->name} years old.";  
	}
	else
	{
		return false;
	}
	  
}

public function getPasswordFromName($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT pword FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->pword;
		//echo "$name is {$result->name} years old.";  
	}
	else
	{
		return false;
	}
	  
}


public function checkIfCoinsMoreThanAmount($nameo, $coino)
{
	
	$name = $nameo;
	$coinAmount = $coino;
	
	$query = $this->connection->query("SELECT coins FROM users WHERE name='$name' AND coins >= '$coinAmount';");
	
	if ($result = $query->fetch_object())
	{
		return true;
		//return $result->level;
		//echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	  
}



 public function checkIfNameExists($nameo)
{
	
	$name = $nameo;
	
	$query = $this->connection->query("SELECT name FROM users WHERE name='$name';");
	
	if ($result = $query->fetch_object())
	{
		return $result->name;
		//return $result->level;
		//echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	  
}
	
 public function checkIfEmailExists($emailo)
{
	
	$email = $emailo;
	
	$query = $this->connection->query("SELECT email FROM users WHERE email='$email';");
	
	if ($result = $query->fetch_object())
	{
		return true;
		//return $result->level;
		//echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	  
}


public function insertNewUser($name, $email, $password)
{
		$query = ("INSERT INTO users (name, email, pword, rank, level, exp, wins, coins) VALUE ('$name', '$email', '$password', '0', '1', '0', '0', '50');");
	
	if ($this->connection->query($query))
	{
		return true;
		//return $result->level;
		//echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	
}

public function insertNewUserIntoItemsTable($name)
{
		$query = ("INSERT INTO items (name, currentItemClass, baseTrowel, greenTrowel, blueTrowel, blackTrowel, pencil, highlighter, fancyPen, hammer, umbrella, wrench, guitar, satelliteDish, telescope, paintBucket, airplane, monkeyHand) VALUE ('$name', 'BaseTrowel', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);");
	
	if ($this->connection->query($query))
	{
		return true;
		//return $result->level;
		//echo "$name is {$result->level} years old.";  
	}
	else
	{
		return false;
	}
	
}

	
	
	public function talk_back($value)
	{
		return "You said " . $value;
	}
	
}

?>