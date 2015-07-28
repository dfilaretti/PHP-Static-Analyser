<?php

	// only Weverca spots the error. Can we too?!

    // innocent string 
    $x = "hello";

    // takes a fun name and an arg, then call
    function call($fname,&$arg) {
        $fname($arg);
    }

    // TAINTS the passed variable (ref pass)
    function foo(&$x) {
        $x = $_GET["taint"];
    }

    // taints the local copy - harmless
    function bar($x) {
        $x = $_GET["taint"];
    }

	if ($_GET["dunno"])
		$f = "foo";
	else
      	$f = "bar";

	// foo may be called and is vulnerable      	
	call($f,$x);

echo $x;

?>
