<?php

class BrimelowTest
{
	public function __construct()
	{
		mysql_connect("newer.cwglba5cwihw.us-east-1.rds.amazonaws.com:3306", "bob", "jam12345");	
//		mysql_select_db("UserInfo");
	}
	/**
	*   Retrieves data from db
	*
	**/
	
	function getStuff()
	{
		return mysql_query("SELECT * FROM users");
	}
	
	
	function lookUpUser()
	{
		
		$sql = "SELECT * FROM UserInfo.users WHERE name='derrick'";
		
		$query = mysql_query($sql);
		
		$login_counter = mysql_num_rows($query);
		
//		return $login_counter;
		
		if ($login_counter > 0) {
		
	/**	while ($data = mysql_fetch_array($query)) {
			$userbio = $data["rank"];
 			$foundName = $data["name"];
	**/
					
			return "jim";
/*
use the print function to send values back to flash
*/
 			
//			print "systemResult=$userbio";
		
		
		
		}
		
		else
		{
			return "couldn't find it in the db";
		}
		
	}
	
	
	
}

?>
