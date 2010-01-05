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
