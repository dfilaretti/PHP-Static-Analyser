
<? // README: feel free to add examples to this file, but:
   // don't delete existing ones unless they are superseded by new ones;
   // write comments to explain examples;
   // ensure examples are commented out individually when commiting file to repo.

//SM debug debugging functionality
/*
function x(){return 1;}
function x(){return "a";}
$y= x();
*/

/*
$x = 1;
$y = "a";
$z =& $x;
if (1){$w = $y;} else {$w =& $y; }

_debug(m("strong aliasing",$x,$z)); 
_debug(h("weak aliasing",$y,$w)); 
_debug(v("values",$x,$x)); 
_debug(v("different values",$x,$y)); 
*/

//SM check cases for comparisons
//$x==true;

//SM check reachabilitiy of branches in loop with nested while
/*
$x=1;
while($x==true){if(42){$z="z1";}else{$w="w1"; break;}$y="y1";
*/

//SM check some merge cases
//if (1){$y="a";$x[0]="k";} else {$y=1; }


//SM merging arrays
//if (1){$x[0]=1;}  //think about this: array is in memeory, element maybenull. seems sound?
//if (1){$x[0]=1;} else {$x=1;} // ok: lub array-int = top

//SM aliasing non-existing element
/*
$x["a"] = 1;
$x["a"] =& $y; // works fine, does strong is key is precise, weak if not precise, and creates y with null
*/

//SM beware if one gets a mergearray stuck with a bagwrap in the heap, it could b edone to scalarvalue missing some case (we have top, null, may need bot)
//if (1) {$x = NULL;} else {$x = NULL;} 


//SM this works
/*
$x["a"] = "a1";
if (1){$x["a"] = "a1";} else {$x["a"] = "a2";} 
*/

//SM testing simple while
/*
$x=1;
while(true){$x = $x+1;} //loop detected, all good
*/

//SM simple may aliasing
// both work like a charm
/*
//$y = "y1";
//if (1){$x = 1;} else {$x =& $y;} 
$x["a"] = "a1";
$x["b"] = "b1";
if (1){$x["b"] =& $x["a"];} else {$x["b"] = 1;} 
*/

/*
//$y = "y1";
$x["a"] = "a1";
$y = "y1";

//if (1){$y =& $x["a"];} else {$y = "y2";} // OK
//if (1){$x["a"] =& $y;} // BROKEN! alias to y1 instead of stringtop 
if (1){$y =& $x["a"];} else {$y=1;} // NOT BROKEN
*/



//SM testing array read/write
/*
$y = "y1";

$x[1] = 1;
$x["c"] = "c1";
$x["d"] = "d1";
$x["e"] =& $x["d"]; //strong aliasing
// so far so good

//(A) works fine
//(but why ARC1? shouldn't count more aliasing? maybe this is right)
//if (1){$w=1;}else{$w="a";}

//(B) perfect, including maybenull
if (1){$w="h";}else{$w="a";}

//(E) WRONG (both ARC2, but not aliased, y gets y1, f gets stringtop
// once this is fixed, check that (C) will probably break aliasing with y (erroneously)
if (1){$x["f"] =& $y;} else {$x["f"] = "f1";} // may aliasing

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


//SM old examples to review, some may be useful
/* this should give wrong result in type domains by not weak updating $z elem
   but it doesn't work baacuse Aint<Lattice NULLL gets stuck (we think)
*/

/*
if (true) {$y="d";}{$y="e";}
if (true) {$z=1;}{$y=null;}

$x[$z] = 1;
$x["a"] = "a";
$x[$y] = "b";
//$x[""] = "b";
*/

/*
// new strong ok
$x = "a";
$w = "b";
$y[$w] =& $x;
*/

/*
// existing strong ok
$x = "a";
$y["b"] = 1;
$y["b"] =& $x;
*/

/*
// new weak ok
$x = "a";
$y[1] =& $x;
*/


/*
// top-weak not ok: misses key to do weak update
$x = "a";
$y[1] = 1;
$y[2] =& $x;
*/


//echo "123" == "\n123"; 

//var_dump( $$this);

/*
$_GET="erf";
function x(){
$r = "_GET";
echo $$r;
echo $_GET;
}
x();
//var_dump($GLOBALS);
*/

/*
$x=2;
$GLOBALS = 1;
//echo $GLOBALS["_GET"];

var_dump($GLOBALS);
echo $_GET;
*/

//function name($x){return $x;}
//echo name(4);

/*
if($t."hello")
{$x[];}
else 
{$y[1]=123;;}
*/

//$y[][][$x[4]]=$f[6];

?>


