$LOAD_PATH << File.join(File.dirname(__FILE__),"lib")

require 'rake/clean'
require 'awstats/conf_handler'

CONFIG_FILE = 'config.yml'

CLOBBER.include "awstats.*-*.conf"

namespace :aws do
  namespace :gen do
    desc "Generates awstats.service-domain.conf files from template"
    task :conf do
      handler = AWStats::ConfHandler.new(File.open(CONFIG_FILE))
      template = File.open(handler.template).read
      handler.conf_files.each do |conf|
        puts "Creating #{conf.target_file}"
        File.open(conf.target_file, "w") { |f| f.write conf.fill_in(template) }
      end
    end

    desc "PENDING: Generates html list file from template"
    task :list do
    end
  end

  desc "PENDING: Run all gen commands"
  task :gen do
  end
end
