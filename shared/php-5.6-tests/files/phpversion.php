<?php
$ver = phpversion();
if ( preg_match("/^5\.6\..*$/", $ver))
{
  echo "Success";
} else {
  echo "Failure";
}

?>
