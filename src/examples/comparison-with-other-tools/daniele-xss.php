<?php

	// Pixy and Weverca: find XSS. 
	// RIPS: doesn't find it

	$y["bar"]["baz"] = $_GET["foo"];
	$z =& $y["bar"]["baz"];
	unset($y["bar"]["foo"]);
	echo $z;
?>
