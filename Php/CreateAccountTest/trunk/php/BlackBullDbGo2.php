<?php

class BlackBullDbGo2
{
	private $connection;
	
	public function __construct()
	{
		$theConnection = mysql_connect("newer.cwglba5cwihw.us-east-1.rds.amazonaws.com:3306", "bob", "james123");
		mysql_select_db("UserInfo", $theConnection);
	
	}
	
	public function create($params)
	{
		$query = "INSERT INTO users (";
		$query .= "name, pword, rank";
		$query .= ") VALUE (";
		$query .= "'{$params[0]}', '{params[1]}', '{params[2]}'";
		
		if ($result = mysql_query($query, $theConnection))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public function reader()
	{
		return mail("yo");	
	}
	
	public function easyRead()
	{
		$query = "SELECT * ";
		$query .= "FROM users";
		$query .= "WHERE name=bob";
		
		return mysql_query($query);
		
	}
	
	public function read()
	{
		$query = "SELECT * ";
		$query .= "FROM users";
		
		$resultSet = mysql_query($query, $this->connection);
		if ($resulSet)
		{
				// return the rows of data in an array
			$rows = array();
			if (mysql_num_rows($resultSet) > 0)
			{
				while($row = mysql_fetch_array($result_set))
				{
					$rows[] = $row;	
				}
			}
	
			else
			{
				// empty table
				$row[0]['name'] = "No Records";
				$row[0]['pword'] = "No PassBrah";
				$row[0]['rank'] = 14;
	
			}
			return $rows;
		}
		
		else
		{
			return false;
		}
		
	}

	public function update($params)
	{
		$query = "UPDATE users SET ";
		$query .= "name = '{$params[1]}', ";
		$query.=  "pword = '{params[2]}' ";
		$query .= "WHERE id = '{$params[0]} ";
		$query .= "LIMIT 1";
		
		if ($result = mysql_query($query, $this->connection))
		{
			return true;
		}
		else
		{
			return false;
		}
	}


	public function delete($id) 
	{
		$query = "DELETE FROM users ";
		$query .= "WHERE name = {$name} ";
		$query .= "LIMIT 1";
		
		if ($result = mysql_query($query, $this->connection))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

} // class




?>