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

require 'awstats/conffile'
require 'yaml'
require 'erb'

module AWStats
  class ConfHandler

    RESERVED_KEYS = %w(default template targetformat)

    attr_reader :conf_files, :html_template, :html_outfile

    def initialize(stream)
      @config = YAML::load(stream)
      @defaults = @config['defaults']
      @hosts = @config['configs']

      @conf_files = @hosts.collect do |h|
        ConfFile.new(h, @defaults)
      end

      @html_template = @config['html_list']['template']
      @html_outfile = @config['html_list']['outfile']
    end

    def generate_html_list(input)
      template = ERB.new(input)
      return template.result(binding)
    end
  end # class ConfHandler
end # module AWStats
