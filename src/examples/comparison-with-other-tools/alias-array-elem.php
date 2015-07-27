<?php
	// Pixy misses this one 
	// -> it doesn't support aliasing between arra elements
	// (but only between "simple variables")

	// RIPS and Weverca find XSS correctly

	$x[1] = "foo";
	$x[2] = $_POST['evil'];

	$x[1] =& $x[2];

	echo $x[1];
?>
