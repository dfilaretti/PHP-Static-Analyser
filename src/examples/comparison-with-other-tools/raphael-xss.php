<?php

// Pixy: detect 2 errors (1st and 3rd echo). Also give warning
//       if $GET used instead as $_GET (false alarm)
// Weverca: detect 2 errors (1st and 3rd echo).
// RIPS: 3 warnings. False alarm on the 2nd echo


if ($_GET["flag"])
    $y['ind'] = $_GET["usr"];	// tainted
else
    echo "test";

$x= $y['ind'];

echo $x;            // "test", MayBeNull
echo $x+1;          // AInt, ImplicitTypeConversion
echo($x."baz");     // AStringTop, NullTypeConversion

?>
