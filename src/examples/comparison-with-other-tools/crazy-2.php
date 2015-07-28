<?php

// Pixy and RIPS says nothing
// Weverca spots the XSS

// Weird that PIXY sayd nothing. 
// crazy-1 is more complex and it gives some warning there...

function foo($x,$y) {
    $z[$y] = $x;       		// function name
  	$a =& $y;
    $w =& $z[$a];       	// function name in $w
    $w($a);            		// call $x($y)
}

function bar($x) {
    echo $x;
}

foo("bar",$_GET["stuff"]);

?>
