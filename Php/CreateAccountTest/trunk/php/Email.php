<?php

class Email
{	
	/**
	 * This service sends an email
	 * @returns true or false
	 */
	function send($to, $subject, $message, $fromPerson)
	{
		
		$headers .= 'From: Golden Lion Games <support@goldenliongames.com>' . "\r\n";

		return mail($to, $subject, $message, $headers);
	}
}

?>