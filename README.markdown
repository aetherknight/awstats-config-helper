AWStats Config Helpers
======================

* **Author:** William (B.J.) Snow Orvis <aetherknight{at}gmail{dot}com>
* **Created:** 2009-10-11
* **Modified:** 2009-10-11
* **License:** MIT (feel free to modify and redistribute, but please give me
  credit. See the source files for the text of the license)

These scripts are meant to make it easier to configure AWStats for multiple
domains. At present, there are two main helper scripts, written in (and
requiring only) ruby:

* `gen_awstats_conf.rb` - will generate configuration files for multiple domains
* `gen_awstats.conf`    - Configuration for gen_awstats_conf.rb
* `gen_awstats_list.rb` - will print a basic html page that lists links to each
  AWStats page for each configuration

There is also a rebuild.sh script to run both of these scripts automatically.
If you use it, edit it first so that the generated index.html file gets put in
the right place.

The `awstats.model.conf` file should just be used as an example, like the
existing configuration in `gen_awstats_conf.rb`. Both are tailored to my web
server, and the some of the settings and paths in it may not work for you.

Overview
--------

The configuration generation script makes it easier to generate several AWStats
config files from a single template. It is made up of some code and a class
definition, as well as a configuration file that contains blocks of ruby code
to specify how to generate a configuration file for a given domain-service
pair.

The idea is that one can arbitrarily specify each placeholder mark (usually a
sequence like `@DOMAIN@`, inspired by how AutoConf's configure generates a
Makefile from Makefile.in), and map it to an object's attribute to make it
easier to express variable configuration options.

First, there is the `awstats.model.conf` template file. All of the generated
configuration files will be based on it. It should look like a standard awstats
configuration script, but some of the parameters should be set to a placeholder
string rather than an actual value. For example, a line like:

    LogFormat="@LOGFORMAT@"

is not a valid LogFormat declaration, but the `@LOGFORMAT@` placeholder will
get replaced by `gen_awstats_conf.rb` if `gen_awstats.conf` is configured
correctly.

Next is the `gen_awstats.conf` meta-configuration file. It sets up some global
settings for the configuration generating script and then specifies the
configuration for each domain-service pair. Read over the default meta-config
file for an explanation of many of its settings, as well as examples of how it
gets used.

Creating a new Domain
---------------------

To specify a config file to be generated/regenerated, add/edit some lines like:

    AWStatsConf.new "mydomain", :http do |s|
      s.something = "config specific value"
    end

near the bottom of the meta-config file. There should be one such block for
each config file you want created. The first parameter of AWStatsConf.new is
the domain name, and the second parameter is a service name. The resulting
configuration file for the above example would be
`/etc/awstats/awstats.http-mydomain.conf`.

Within the block, attributes can be set to override their default values. The
attributes that can be set are defined in the second class definition in the
configuration part of the script file, using `add_attr`. This will look
something like:

    add_attr :something, "@SOMETHING@", "some default value"

where `:something` corresponds to the s.something attribute, `@SOMETHING@` is a
placeholder mark that will get replaced by either the default value or the
value of `s.something`, and the third field is the default value.

The basic idea is that you can add additional `add_attr` lines and then modify
`awstats.model.conf` to specify where to fill in the values for the generated
config files.


Example of Adding an Extra Variable Parameter
---------------------------------------------

Suppose you will have more than one LogType amongst your derived configuration
files. In order to add this, you will need to edit awstats.model.conf so that:

    LogType="@LOGTYPE@"

Add an add_attr line:

    add_attr :logtype, "@LOGTYPE@", "W"

And specify the change for the non-default cases:

    AWStatsConf.new "somedomain", :smtp do |s|
      s.logtype = "M"
    end

After these changes have been made, run `gen_awstats_conf.rb` to regenerate the
config files with the new changes.


Inspiration
-----------

* http://www.gnu.org/software/autoconf/
* http://www.mattdorn.com/content/automating-awstats-configuration-for-multiple-domains/
