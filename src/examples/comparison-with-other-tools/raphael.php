<?php

// This is about types. 
// Should be tested on PHANTM but it's a problem to make it work 

$y=array("foo" => "bar");

if ($GET['foo'])
    {$y['ind'] = "test";}
else
    {$y['ind2']="test2";}

$x= $y['ind'];

echo $x;            // "test", MayBeNull
echo $x+1;          // AInt, ImplicitTypeConversion
echo($x."baz");     // AStringTop, NullTypeConversion
?>
