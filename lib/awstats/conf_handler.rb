require 'awstats/conffile'
require 'yaml'

module AWStats
  class ConfHandler

    RESERVED_KEYS = %w(default template targetformat)

    attr_accessor :conf_files

    def initialize(stream)
      @config = YAML::load(stream)
      @defaults = @config['defaults']
      @hosts = @config['configs']

      @conf_files = @hosts.collect{ |h| ConfFile.new(h, @defaults) }
    end

  end # class ConfHandler
end # module AWStats
