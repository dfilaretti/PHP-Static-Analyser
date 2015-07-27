<?php
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
