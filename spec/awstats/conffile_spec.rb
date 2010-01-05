require 'spec_helper'
require 'awstats/conffile'

module AWStats
  describe ConfFile do

    def defaults
      @defaults ||= {
        'domain' => 'localhost',
        'service' => 'http',
        'aliases' => '',
        'logfile' => '/var/log/apache2/access_log',
        'logformat' => '%time1 %host %other %logname %virtualname %methodurl ' +
            '%code %bytesd %refererquot %uaquot %other'
      }
    end


    describe "the usual attributes" do
      context "when it only uses default values" do
        it "should always return requested default values" do
          conffile = ConfFile.new(nil, defaults)

          conffile.domain.should == defaults['domain']
          conffile.service.should == defaults['service']
          conffile.aliases.should == defaults['aliases']
          conffile.logfile.should == defaults['logfile']
          conffile.logformat.should == defaults['logformat']
        end
      end

      context "when it has some of its own values" do
        it "should return its own values instead of defaults" do
          config = {
            'domain' => 'anotherhost',
            'service' => 'https'
          }
          conffile = ConfFile.new(config, defaults)

          conffile.domain.should == config['domain']
          conffile.service.should == config['service']
          conffile.aliases.should == defaults['aliases']
          conffile.logfile.should == defaults['logfile']
          conffile.logformat.should == defaults['logformat']
        end
      end

      context "when it has all of its own values" do
        it "should return its own values instead of defaults" do
          config = {
            'domain' => 'anotherhost',
            'service' => 'https',
            'aliases' => %w(localhost anotherhost.local),
            'logfile' => '/some/log/file',
            'logformat' => 'some %format %for %loglines'
          }
          conffile = ConfFile.new(config, defaults)

          conffile.domain.should == config['domain']
          conffile.service.should == config['service']
          conffile.aliases.should == config['aliases']
          conffile.logfile.should == config['logfile']
          conffile.logformat.should == config['logformat']
        end
      end

    end # describe the usual attributes

  end # describe ConfFile
end # module AWStats
