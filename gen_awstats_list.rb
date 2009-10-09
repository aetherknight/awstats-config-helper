#!/usr/bin/env ruby

BASEURL="/cgi-bin/awstats.pl"
CONFDIR="/etc/awstats"

puts "<html>"
puts "<head>"
puts "</head>"
puts "<body>"

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
