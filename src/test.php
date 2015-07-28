<?php
echo(0 == 0); // 0 == 0 -> true
echo(0 == "a"); // 0 == 0 -> true
echo("1" == "01"); // 1 == 1 -> true
echo("10" == "1e1"); // 10 == 10 -> true
echo(100 == "1e2"); // 100 == 100 -> true

switch ("a") {
case 0:
    echo "0";
    break;
case "a": // never reached because "a" is already matched with 0
    echo "a";
    break;
}

/*
$x[NULL] = 123;
var_dump($x);
*/
/*
=======
/*
class foo { 
	public $a = "foo";
	public function bar() { 
		echo $this->a;
		$x="this";
		echo $$x->a;
	} 
} 

$y = new foo;
$y->bar();
*/

?>
