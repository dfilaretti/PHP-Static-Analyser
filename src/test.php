<?php
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
?>
