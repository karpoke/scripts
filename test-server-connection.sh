#!/bin/bash
# https://blog.josephscott.org/2011/10/14/timing-details-with-curl/

FORMAT="""
            time_namelookup:  %{time_namelookup}
               time_connect:  %{time_connect}
            time_appconnect:  %{time_appconnect}
           time_pretransfer:  %{time_pretransfer}
              time_redirect:  %{time_redirect}
         time_starttransfer:  %{time_starttransfer}
                            ----------
                 time_total:  %{time_total}
"""

/usr/bin/curl \
    -w "$FORMAT" \
    -o /dev/null \
    -s \
    "$*"

