<?php	

// Adaptation of our earlier ECOOP example

// Weverca and Pixy report NO vulnerability (unsound)
// Apparently, they take the "twotwo" approach in both cases, missing the 
// vulnerability in the first snippet. 

$a = array($_POST["one"]);
$c = $a[0] . ($a[0] = "two");
echo $c; // “onetwo"
echo "\n";

$a = $_POST["one"];
$c = $a . ($a = "two");
echo $c; // "twotwo"
echo "\n";
?>
