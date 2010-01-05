#!/bin/sh
INDEX_PAGE="/srv/www/org.aedifice/private/htdocs/awstats/index.html"


cd `dirname $0`
echo "Generating configs:"
rake aws:gen:conf
echo ""
echo "Generating ${INDEX_PAGE}"
./gen_awstats_list.rb > ${INDEX_PAGE}
echo "Done"
