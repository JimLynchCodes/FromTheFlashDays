<?php

class BrimelowDbTest
{
	public function __construct()
	{
		mysql_connect("newer.cwglba5cwihw.us-east-1.rds.amazonaws.com:3306", "bob", "jam12345")	
	
	mysql_select_db("UserInfo");
	}
	/**
	*   Retrieves data from db
	*
	**/
	
	function getStuff()
	{
		return mysql_query("SELECT name, rank FROM users");
	}
}

?>
