<?php

send_data("Sugi", "93.114.82.74", 27014);

function send_data($data, $address, $port){

	/* Create a TCP/IP socket. */
	$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
	if (!$socket) 
	{
		error_log("socket_create() failed: reason: " . socket_strerror(socket_last_error()));
		return -1;
	}

	// Attempting to connect to '$address' on port '$port'
	$result = socket_connect($socket, $address, $port);
	if ($result === false) 
	{
	    error_log("socket_connect() failed.\nReason: ($result) " . socket_strerror(socket_last_error($socket)));
		return -1;
	} 


	// Sending Data
	if(!socket_send($socket, $data, strlen($data), 0)){
		$errorcode = socket_last_error();
		$errormsg = socket_strerror($errorcode);
		error_log("Could not send data: [{$errorcode}] {$errormsg}");
		return -1;
	}

	// Closing socket
	socket_close($socket);

	return 1;
}


?>