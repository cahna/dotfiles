#!/bin/sh
cal | awk 'NR>1' | sed -e 's/   /    /g' -e 's/[^ ] /& /g' -e 's/..*/  & /' -e 's/ \('`date | awk '{print $3}'`'\) /\['`date | awk '{print $3}'`'\]/'
