#!/bin/bash

# https://gist.github.com/kamermans/1076290
JAILS=$(/usr/bin/fail2ban-client status | tail -1 | awk -F: '{print $2}' | sed 's/,//g')
for JAIL in $JAILS; do
    /usr/bin/fail2ban-client status "$JAIL"
done
