#!/usr/bin/env ruby
#--
# (The MIT License)
#
# Copyright (c) 2009 William Snow Orvis
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

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
