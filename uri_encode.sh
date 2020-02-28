#!/bin/bash

# perl do not convert ( and ) to %28 and %29
# perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*"
python -c "from __future__ import print_function; import urllib; print(urllib.quote('''$*'''), end='')"
