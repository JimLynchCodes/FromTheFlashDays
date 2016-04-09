<?php

class Email
{	
	/**
	 * This service sends an email
	 * @returns true or false
	 */
	 
	function send($to, $subject, $message, $fromPerson, $fromPersonName)
	{
		
		$header = "Reply-To: ".$fromPersonName." <".$fromPerson.">\r\n"; 
   	    $header .= "Return-Path: ".$fromPersonName." <".$fromPerson.">\r\n"; 
        $header .= "From: ".$fromPersonName." <".$fromPerson.">\r\n"; 
      //  $header .= "Organization: My Organization\r\n"; 
        $header .= "Content-Type: text/plain\r\n"; 
		

		return mail($to, $subject, $message, $header);
	}
}

?>