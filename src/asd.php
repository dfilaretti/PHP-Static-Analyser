<? // README: feel free to add examples to this file, but:
   // don't delete existing ones unless they are superseded by new ones;
   // write comments to explain examples;
   // ensure examples are commented out individually when commiting file to repo.


//SM testing array read/write
/*
$y = "y1";

$x[1] = 1;
$x[2] = 2;
$x["c"] = "c1";
$x["d"] = "d1";
// so far so good

//(A) works fine
//(but why ARC1? shouldn't count more aliasing? maybe this is right)
//if (1){$w=1;}else{$w="a";}

//(B) perfect, including maybenull
//if (1){$w="h";}else{$w="a";}

//(C) weird, without (A) or (B) gives "w1"-maybenull, but null shouldn't be here.
// is it propagated by mystake by key that has nulltypeconversion?
//$x[$w] = "w1";

// with (A) ok: $y gets ARC2 Top and all other keys weakly aliased to it 
// with (B)
//$x[$w] =& $y;
*/


//SM testing globals/superglobals resolution
/*
$x= "------------------";
$_FILES= "@@@@@@@@@@@@@@@@@@@@@@@";
*/


//SM testing empy array access []
/*
$x[];
*/

/*
if (4*4)
 {$r="doh";} else
{$y="asd";$x[];};
*/

/*$y=$z[];

$r["hkj"]=5;
$r["hkj"];
*/


//SM testing var_dump
/*
$q = 1;
$f = "hello";
var_dump($q,$f,$q);
*/
?>