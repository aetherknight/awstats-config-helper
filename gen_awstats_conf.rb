#!/usr/bin/env ruby
# Generates awstats.sitename.conf files in /etc/awstats more easily by
# specifying just the varying parts in this file, and filling in placeholder
# marks within /etc/awstats.model.conf.
#
# After the main block of code, there is another class definition to define
# constants for all of the AWStatsConf objects generated. After that, you can
# add new AWStatsConf blocks at the bottom of the file. Each block should look
# something like:
#
#   AWStatsConf.new "www.aedifice.org", :http do |s|
#     s.aliases = "localhost ouroboros.aedifice.org aedifice.org"
#     s.logfile = "/var/log/apache2/access_log"
#   end


##############################################################################
# Replaces placeholder marks on in_io, and writes the result to out_io.
#
# This is meant to be similar to what autoconf configure scripts do.
#
# == Input
# in_io  [#each_line] An input stream to look for placeholder marks in. Must
#                     be opened for reading.
#
# out_io [#write]     An output stream that the replaced text will be written
#                     to. Must be opened for writing.
#
# args   [Hash]       Keys are placeholder marks, values are what to replace
#                     them with.
#
# == Result
# in_io is copied to out_io, except that anywhere where a key string appears,
# it is replaced with the key's corresponding value
#
# == Example
# Suppose an in_io has a line like:
#
#   PREFIX=@PREFIX@
#
# And then replace_placeholders is called as:
#
#   replace_placeholders(some_in, some_out, { "@PREFIX@" => "/usr/local" } )
#
# Then the corresponding line in some_out would be:
#
#   PREFIX=/usr/local
#
# The double @ sign approach is purely convention, and any string may be used.
# Note that there is no recursion on the placeholder strings and replacement.
def replace_placeholders(in_io, out_io, args)
  in_io.each_line do |line|
    args.each_key do |key|
      line.sub!(key, args[key])
    end
    out_io.write(line)
  end
end

class AWStatsConf
  # The domain name this AWStatConf will cover
  attr_accessor :domain
  # A type prefix because a given domain could have more than one conf.
  attr_accessor :type
  # A list of domain name aliases.
  attr_accessor :aliases
  # Path to a logfile to get the data from.
  attr_accessor :logfile

  def initialize(domain, type, &block)
    # Set some defaults
    self.domain = "localhost"
    self.type = :http
    self.aliases = ""
    self.logfile = "/var/log/apache2/access_log"
    # Override defaults with the block
    self.instance_eval(&block)
    # Construct the config file itself
    self.gen_config
  end

  # Create the config file
  def gen_config()
    prefix = self.type.to_s + "-"
    confname = "/etc/awstats/awstats.#{prefix}#{self.domain}.conf"
    puts "Generating #{confname}"

    replace_args = {}
    replace_args["@DOMAIN@"] = self.domain
    replace_args["@ALIASES@"] = self.aliases
    replace_args["@LOGFILE@"] = self.logfile

    in_file = File.new(TEMPLATE, "r")
    out_file = File.new(confname, "w")
    begin
      replace_placeholders(in_file, out_file, replace_args)
    ensure
      in_file.close
      out_file.close
    end
  end
end

##############################################################################
# Edit things after this point.

class AWStatsConf
  TEMPLATE = "/etc/awstats/awstats.model.conf"
end

AWStatsConf.new "www.aedifice.org", :http do |s|
  s.aliases = "localhost ouroboros.aedifice.org aedifice.org ouroboros.local ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "dev.aedifice.org", :http do |s|
  s.aliases = "dev.ouroboros.local dev.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "dev.aedifice.org", :https do |s|
  s.aliases = "dev.ouroboros.local dev.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/ssl_access_log"
end
AWStatsConf.new "blog.aedifice.org", :http do |s|
  s.aliases = "blog.ouroboros.local blog.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "lists.aedifice.org", :http do |s|
  s.aliases = "lists.ouroboros.local lists.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "nethack.aedifice.org", :http do |s|
  s.aliases = "nethack.ouroboros.local nethack.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "private.aedifice.org", :http do |s|
  s.aliases = "localhost private.ouroboros.local private.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/access_log"
end
AWStatsConf.new "blog.aedifice.org", :https do |s|
  s.aliases = "localhost blog.ouroboros.local blog.ouroboros.homedns.org"
  s.logfile = "/var/log/apache2/ssl_access_log"
end

