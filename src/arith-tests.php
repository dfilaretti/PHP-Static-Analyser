<?php

echo true;
echo false;

echo "inttests";

echo(0 == 2); // 0 == 0 -> true
echo(0 == "a"); // 0 == 0 -> true
echo("1" == "01"); // 1 == 1 -> true
echo("10" == "1e1"); // 10 == 10 -> true
echo(100 == "1e2"); // 100 == 100 -> true

echo "booltests";

if ("1"=="01")
{$x="1";}
else
{$x=2;}

echo(""==false);
echo("1"==false);
echo(NULL==true);
echo($x == false);
echo($x ==5);
echo($x==$x);

?>