<?php

$xml = simplexml_load_file('quotes.xml');

if(!empty($xml))
{
   echo ("Success");
} else {
   echo ("Failure");
}

?>
