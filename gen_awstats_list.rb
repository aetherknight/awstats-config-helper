#!/usr/bin/env ruby

BASEURL="/cgi-bin/awstats.pl"
CONFDIR="/etc/awstats"

puts "<html>"
puts "<head>"
puts "<title>List of AWStats Domains</title>"
puts "</head>"
puts "<body>"

puts "<h1>List of AWStats Domains</h1>"
puts "<ul>"

sites = []
Dir.foreach(CONFDIR) { |f|
  if (res = /awstats\.(.*)\.conf/.match(f)) != nil and res[1] != "model"
    sites << res[1]
  end
}
sites.sort.each { |s|
  puts "  <li><a href=\"#{BASEURL}?config=#{s}\">#{s}</a></li>"
}

puts "</ul>"

puts "</body>"
puts "</html>"
