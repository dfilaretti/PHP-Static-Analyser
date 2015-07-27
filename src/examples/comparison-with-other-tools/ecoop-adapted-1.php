<?php	

// Adaptation of our earlier ECOOP example

// Both vulnerabilities found (Pixy, Weverca).

$a = array("one");
$c = $a[0] . ($a[0] = $_POST["two"]);
echo $c; // “onetwo"
echo "\n";

$a = "one";
$c = $a . ($a = $_POST["two"]);
echo $c; // "twotwo"
echo "\n";

?>
