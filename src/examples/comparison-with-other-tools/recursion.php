<?php
	// Pixy, RIPS and Weverca all find a vulnerbility 
	function foo() {
		if ($_GET["test"]) {
			foo();
		}
		else {
			echo $_GET["usr"];
		}
	}
	foo();
?>

