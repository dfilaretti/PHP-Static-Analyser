<?php
	// Pixy and Weverca gives a false positive in this case
	// RIPS: no false positives! 

	$a = array("one");
	$c = $a[0] . htmlspecialchars($a[0] = $_POST["two"]);
	echo $c; // “onetwo"
	echo "\n";
?>
