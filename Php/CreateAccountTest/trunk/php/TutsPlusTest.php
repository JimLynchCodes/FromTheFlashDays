<?php

class BrimelowTest
{
	public function __construct()
	{
		mysql_connect("newer.cwglba5cwihw.us-east-1.rds.amazonaws.com:3306", "bob", "jam12345");	
		mysql_select_db("UserInfo");
	}
	/**
	*   Retrieves data from db
	*
	**/
	
	function getStuff()
	{
		return mysql_query("SELECT name FROM users");
	}
	
	
	function lookUpUser()
	{
		$username = $_POST['username'];
		$password = $_POST['password'];
		
		if ($_POST['systemCall'] == 'checkLogin')
		{
			$sql = "SELECT * FROM users WHERE pword='jim'";
		
			$query = mysql_query($sql);
			
			$login_counter = mysql_num_rows($query);
		
			if ($login_counter > 0) {
		
				while ($data = mysql_fetch_array($query)) {
					$userbio = $data["rank"];
 					$foundName = $data["name"];
					/*
					use the print function to send values back to flash
					*/
 
					print "systemResult=$userbio" ;
					print "name=$foundName";
					return $userbio;
				}
				
				
			}
			
			else
				{
					print "none found. sorry brah";
				}
		
		}
		
	}
	
	
	
}

?>
