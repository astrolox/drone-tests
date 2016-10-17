#!/bin/bash
printf "Content-type: text/html\n\n"
printf "<br />\n"

printf "Remote address: $HTTP_REMOTE_ADDR<br />\n"
printf "Server Port: $SERVER_PORT<br />\n"
#printf "X-Forwarded-For: $HTTP_X_FORWARDED_FOR<br />\n"
#printf "X-Forwarded-Port: $HTTP_X_FORWARDED_PORT<br />\n"
