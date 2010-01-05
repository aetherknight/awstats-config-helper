AWStats Config Helpers
======================

* **Author:** William (B.J.) Snow Orvis <aetherknight{at}gmail{dot}com>
* **License:** MIT (feel free to modify and redistribute, but please give me
  credit. See the source files for the text of the license)

This Rakefile and associated ruby code is intended to make it easier to
configure AWStats for multiple domains. At present, there are two main tasks,
and several supplemental tasks:

* `rake aws:gen:conf`   - Generates configuration files for multiple domains
* `rake aws:gen:list`   - Generates a basic html page that lists links to each
  AWStats page for each configuration
* `rake aws:gen`        - Runs both of the above tasks
* `rake spec`           - Runs rspec tests for code in `lib` (hidden if rspec
  is not installed)

The tasks are configured using `config.yml`. It has three main sections:

* **defaults**  - Default options for each service-type--domain-name pair.
* **configs**   - A yaml list where each entry corresponds to a generated
  config file.
* **html_list** - Some settings for `aws:gen:list`.

The `config.yml` file should be tailored to your own configuration. It comes
set up close to what I use on my personal web server, and some of the settings
and paths in it may not work for you.

There are also two erb template files, `awstats.model.conf.erb` and
`index.html.erb`. The former is the (verbose) sample `awstats.model.conf` that
comes with awstats, and it is provided as an example of how to add the erb
syntax, but it will probably work for most configurations.

Overview
--------

`rake aws:gen:conf` makes it easier to generate several AWStats config files
from a single template.

First, there is the `awstats.model.conf.erb` template file. All of the
generated configuration files will be based on it. It should look like a
standard awstats configuration script, but some of the parameters should be set
to an erb string rather than an actual value. For example, a line like:

    LogFormat="<%= logformat %>"

is not a valid LogFormat declaration, but the `<%= logformat %>` placeholder
will get replaced with a value from the current host configuration.

Next is the `config.yml` meta-configuration file. It sets up some default
settings for the generated configurations and then specifies the configuration
for each service--domain pair. Read over the default `config.yml` file for an
explanation of many of its settings, as well as examples of how it gets used.

Creating a new Domain
---------------------

To specify a config file to be generated/regenerated, add/edit some lines like:

    configs:
    ...
    - domain: mydomain
      service: http
      something: some specific value

as part of the list of configurations. There should be one such block for
each config file you want created. Within the `awstats.model.conf.erb` template
file, each left-hand parameter will get replaced with a right-hand value in the
final output. If the block does not specify a value used in the template file,
a value from the default section will get used instead (and if it does not
exist there either, an error will occur).


Adding an Extra Variable Parameter
----------------------------------

It is also possible to add your own attributes to the template file and
config.yml.  Suppose you will have more than one LogType amongst your derived
configuration files. In order to add this, you will need to edit
`awstats.model.conf.erb` so that:

    LogType="<%= logtype %>"

Add a default value:

    defaults:
    ...
    logtype: W

And specify the change for the non-default cases:

    configs:
    ...
    - domain: somedomain
      service: smtp
      logtype: M

After these changes have been made, run `rake aws:gen:conf` to regenerate the
config files with the new changes.


Original Inspiration
--------------------

Since rewriting this tool to use Rake and ERB, it does not really look anything
like the following projects anymore. However, they are still worth mentioning.

* http://www.gnu.org/software/autoconf/
* http://www.mattdorn.com/content/automating-awstats-configuration-for-multiple-domains/
