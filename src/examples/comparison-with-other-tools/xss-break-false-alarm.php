<?php
	// Pixy and Weverca: no vuln found (correct)
	// RIPS: false positive (doesn't stop at break)

	$x = "hello";
    while (true) {
    	if ($_GET["test"])
          	break;
      	else {
          	$x = $_GET["foo"];
            break;
          	echo $x;
      	}
    }
?>
