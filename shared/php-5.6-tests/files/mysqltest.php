<?php
$item = "'1";
$escaped_item = mysql_escape_string($item);
$check = "\'1";

if (strcmp($escaped_item, $check) == 0)  {
    echo "Success";
} else {
    echo "Failure";
}
?>