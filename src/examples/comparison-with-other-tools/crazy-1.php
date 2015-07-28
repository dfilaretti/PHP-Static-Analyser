<?php

// Pixy says nothing
// RIPS says "arbitrary function may be called"
// Weverca spots the XSS

function foo($x,$y) {
    $z[$y] =& $x;       		// function name
	$z[$x] =& $y;				// parameter
  	$a =& $y;
	$b =& $x;
    $w =& $z[$a];       		// function name in $w
    $w($z[$b]);            		// call $x($y)
}

function bar($x) {
    echo $x;
}

foo("bar",$_GET["something"]);

?>
