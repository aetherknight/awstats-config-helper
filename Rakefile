$LOAD_PATH << File.join(File.dirname(__FILE__),"lib")

require 'rake/clean'
require 'awstats/conf_handler'

CONFIG_FILE = 'config.yml'

handler = AWStats::ConfHandler.new(File.open(CONFIG_FILE))

namespace :aws do
  namespace :gen do

    desc "Generates awstats.service-domain.conf files from template"
    task :conf do
      template = File.open(handler.template).read
      handler.conf_files.each do |conf|
        puts "Creating #{conf.target_file}"
        File.open(conf.target_file, "w") { |f| f.write conf.fill_in(template) }
      end
    end
    CLOBBER.include "awstats.*-*.conf"

    desc "Generates html list file from template"
    task :list do
      template = File.open(handler.html_template).read
      File.open(handler.html_outfile, "w") do |f|
        puts "Creating #{handler.html_outfile}"
        f.write handler.generate_html_list(template)
      end
    end
    CLOBBER.include handler.html_outfile

  end

  desc "PENDING: Run all gen commands"
  task :gen do
  end
end
