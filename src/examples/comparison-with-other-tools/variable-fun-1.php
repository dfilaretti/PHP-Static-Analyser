<?php

	// Pixy, RIPS: no vuln found
	// Weverca: found

	function select($fname,$arg) {
		$result = $fname($arg);
	}

	function foo($x) {
		echo $x;
	}

	function bar($x) {
		echo $x;
	}

	if ($_GET["something-random"])
		$fun = "foo";
	else
		$fun = "bar";

	select($fun,$_GET["tainted-date"]);
?>

