<?php

	// RIPS find one vulnerability (false alarm)
	// Weverca and Pixy doesn't 

	function foo() {
		if ($_GET["test"]) {
			foo();
		}
		else {
			echo $_GET["usr"];
		}
		// if XSS was here, Pixy reports false alarm!!!
	}
?>

