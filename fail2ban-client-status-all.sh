#!/bin/sh

# https://gist.github.com/kamermans/1076290
fail2ban-client status | tail -1 | awk -F: '{print $2}' | sed 's/,//g' | xargs -n1 fail2ban-client status

