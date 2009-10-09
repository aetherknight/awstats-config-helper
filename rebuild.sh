#!/bin/sh
cd `dirname $0`
echo "Generating configs:"
./gen_awstats_conf.sh
echo ""
echo "Generating webpage list"
./gen_awstats_list.rb > /srv/www/org.aedifice/private/htdocs/awstats/index.html
echo "Done"
