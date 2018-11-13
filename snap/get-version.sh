#!/bin/sh
rev=`svn info http://svn.code.sf.net/p/scidvspc/code/ | grep Revision | cut -d ':' -f 2 | tr -d ' '`
echo "svn-$rev-20181113"

