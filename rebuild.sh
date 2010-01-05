#!/bin/sh

cd `dirname $0`
echo "Generating configs:"
rake aws:gen:conf
echo ""
echo "Generating index.html"
rake aws:gen:list
echo "Done"
