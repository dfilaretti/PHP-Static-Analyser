<?php
	// Pixy and Weverca gives a false positive in this case
	// (couldn't run RIPS and PHANTM)

	$a = array("one");
	$c = $a[0] . htmlspecialchars($a[0] = $_POST["two"]);
	echo $c; // “onetwo"
	echo "\n";
?>
