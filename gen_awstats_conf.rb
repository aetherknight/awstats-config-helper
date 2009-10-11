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
    args.each do |key, value|
      line.sub!(key, value)
    end
    out_io.write(line)
  end
end

# Each instance represents a single AWStats config file to be generated.
# Instance attributes are dynamically declared using the add_attr class method,
# and they will be used to replace the placeholder marks in the TEMPLATE file
# to generate each config file.
class AWStatsConf
  # The domain name that this config file represents.
  attr_accessor :domain
  # domain already exists, but it does not hurt to redeclare it. (Such as http
  # and https)
  attr_accessor :stype

  # Holds the attribute-placeholder pairings
  @@attr_ph_map = {}
  # Holds the attribute-default pairings
  @@defaults = {}

  # Specify an attribute, the placeholder it's value will replace, and the
  # default value.
  def self.add_attr(sym, placeholder, default)
    attr_accessor sym
    @@attr_ph_map[sym] = placeholder
    @@defaults[sym] = default
  end

  def initialize(domain, stype, &block)
    # Set some defaults
    @@defaults.each do |attr, default|
      instance_variable_set("@#{attr.to_s}", default)
    end
    @domain = domain
    @stype = stype
    # Override defaults with the block
    self.instance_eval(&block)
    # Construct the config file itself
    self.gen_config
  end

  # Create the config file
  def gen_config()
    confname = sprintf(TARGETFORMAT, "#{@stype.to_s}-#{@domain}")
    puts "Generating #{confname}"

    replace_args = {}
    @@attr_ph_map.each do |attr, ph|
      #puts "#{attr}: #{ph}: @#{attr.to_s}"
      replace_args[ph] = self.instance_variable_get( "@#{attr.to_s}")
    end

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

# Specify classwide settings
class AWStatsConf
  # The template file to generate the site-specific files from
  TEMPLATE = "/etc/awstats/awstats.model.conf"
  # A format string with a single %s to insert the type-domain.
  TARGETFORMAT = "/etc/awstats/awstats.%s.conf"

  # Add attribute-placeholder mappings, and the default values.
  add_attr :domain, "@DOMAIN@", "localhost"
  add_attr :aliases, "@ALIASES@", ""
  add_attr :logfile, "@LOGFILE@", "/var/log/apache2/access_log"
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

