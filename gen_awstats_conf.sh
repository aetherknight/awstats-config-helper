#!/bin/bash

# add_domain "vhost_name" "alias list"
function add_domain() {
    local DOMAIN=$1
    local TYPE=$2
    local ALIASES=$3
    local LOGFILE=$4
    local prefix=""

    if [ "$TYPE" = "http" ] ; then
        prefix="http-"
    elif [ "$TYPE" = "https" ] ; then
        prefix="https-"
    fi

    echo "Generating awstat conf file for $DOMAIN"

    cat /etc/awstats/awstats.model.conf | \
    sed -e "s/@DOMAIN@/$DOMAIN/g" \
        -e "s/@ALIASES@/$ALIASES/g" \
        -e "s|@LOGFILE@|$LOGFILE|g" \
        > "/etc/awstats/awstats.$prefix$DOMAIN.conf"
}

add_domain "www.aedifice.org" http "localhost ouroboros.aedifice.org aedifice.org ouroboros.local ouroboros.homedns.org" "/var/log/apache2/access_log"
add_domain "dev.aedifice.org" http "dev.ouroboros.local dev.ouroboros.homedns.org" "/var/log/apache2/access_log"
add_domain "dev.aedifice.org" https "dev.ouroboros.local dev.ouroboros.homedns.org" "/var/log/apache2/ssl_access_log"
add_domain "blog.aedifice.org" http "blog.ouroboros.local blog.ouroboros.homedns.org" "/var/log/apache2/access_log"
add_domain "lists.aedifice.org" http "lists.ouroboros.local lists.ouroboros.homedns.org" "/var/log/apache2/access_log"
add_domain "nethack.aedifice.org" http "nethack.ouroboros.local nethack.ouroboros.homedns.org" "/var/log/apache2/access_log"
add_domain "private.aedifice.org" http "localhost private.ouroboros.local private.ouroboros.homedns.org" "/var/log/apache2/access_log"

