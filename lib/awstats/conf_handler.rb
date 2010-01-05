require 'awstats/conffile'
require 'yaml'

module AWStats
  class ConfHandler

    RESERVED_KEYS = %w(default template targetformat)

    attr_accessor :conf_files, :template

    def initialize(stream)
      @config = YAML::load(stream)
      @template = @config['template']
      @targetformat = @config['targetformat']
      @defaults = @config['defaults']
      @hosts = @config['configs']

      @conf_files = @hosts.collect do |h|
        ConfFile.new(h, @defaults, @targetformat)
      end
    end

  end # class ConfHandler
end # module AWStats
