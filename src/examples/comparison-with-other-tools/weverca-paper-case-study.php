<?php

// Initial example from the Weverca paprt
// NOTE: it will not run, it need stubs for functions...

class Templ { 
	function log($msg) {...}
} 
class Templ1 : Templ {
	function show($msg) { sink($msg); }
} 

class Templ2 : Templ {
	function show($msg) { not_sink($msg); }
}

function initialize(&$users) {
	$users[’admin’][’addr’] = get_admin_addr_from_db();
} 

switch (DEBUG) { 
	case true: $mode = "log"; break;
	default: $mode = "show";
} 

switch ($_GET[’skin’]) {
	case ’skin1’: $t = new Templ1(); break;
	default: $t = new Templ2();
} 

initialize($users); 
$id = $_GET[’userId’];
$users[$id][’name’] = $_GET[’name’]; 
$users[$id][’addr’] = $_GET[’addr’];
$t−>$mode($users[$id][’name’]);
?>
