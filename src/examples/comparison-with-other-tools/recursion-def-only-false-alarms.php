<?php

	// Pixy and RIPS find one vulnerability (corect)
	// Weverca doesn't 

	function foo() {
		if ($_GET["test"]) {
			foo();
		}
		else {
			echo $_GET["usr"];
		}
	}
?>

