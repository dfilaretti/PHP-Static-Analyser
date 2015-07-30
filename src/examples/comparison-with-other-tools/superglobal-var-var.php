<?php

// Superglobals cannot be used as vatiable variables
// So, no vulneravility is present here

// Pixy and RIPS silent
// Weverca: false alarm!! 

function foo() {

    if ($_GET["something"])
      $v = "_GET";
    else
        $v = "z";

    $r = $$v;

    echo $r["usr"];
}

foo();

?>

