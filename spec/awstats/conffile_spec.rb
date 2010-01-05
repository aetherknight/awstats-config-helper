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
          conffile.aliases.should == config['aliases'].join(' ')
          conffile.logfile.should == config['logfile']
          conffile.logformat.should == config['logformat']
        end
      end

    end # describe the usual attributes

    describe "handling arbitrary config keys" do
      context "when it has only a default hash" do
        it "should provide accessor methods for arbitrary hash values" do
          custom_defaults = { 'love' => 'and peace' }
          conffile = ConfFile.new(nil, custom_defaults)

          conffile.love.should == custom_defaults['love']
        end
      end
      context "when it has some values in a config hash" do
        it "should provide accessor methods for arbitrary hash values" do
          config = { 'love' => 'and peace' }
          conffile = ConfFile.new(config, defaults)

          conffile.love.should == config['love']
        end
      end

      it "should raise NoMethodError for nonexistant method => value maps" do
        config = { 'love' => 'and peace' }
        conffile = ConfFile.new(config, defaults)

        lambda { conffile.hate }.should raise_error(
          NoMethodError,
          /^undefined method `hate' for #<.*ConfFile.*>$/ )
      end
    end # describe handling arbitrary config keys

    describe "handling the aliases array" do
      it "should turn the aliases array into a space delimited string" do
        config = { 'aliases' => %w(localhost anotherhost) }
        conffile = ConfFile.new(config, defaults)

        conffile.aliases.should match "localhost anotherhost"
      end

      it "should turn the aliases array into a space delimited string" do
        config = { 'domain' => 'somedomain' }
        custom_defaults = { 'aliases' => %w(athird afourth) }
        conffile = ConfFile.new(config, custom_defaults)

        conffile.aliases.should match "athird afourth"
      end
    end # describe handling the aliases array

    describe "#fill_in" do
      it "should provide the ConfFile's methods to an erb template" do
        config = { 'domain' => 'somedomain',
          'aliases' => %w(localhost anotherhost)
        }
        intext = <<-QUOTE
SiteDomain="<%= domain %>"
HostAliases="<%= aliases %>"
QUOTE
        conffile = ConfFile.new(config, defaults)

        output = conffile.fill_in(intext)
        output.should match %Q{SiteDomain="somedomain"}
        output.should match %Q{HostAliases="localhost anotherhost"}
      end
    end # describe #fill_in

    describe "#target_file" do
      it "returns a filename based on service, domain, and a format string" do
        config = { 'domain' => 'somedomain', 'service' => 'http' }
        targetformat = "awstats.%s.conf"
        conffile = ConfFile.new(config, defaults, targetformat)

        conffile.target_file.should == (targetformat % 'http-somedomain')
      end
      it "returns nil if service or domain do not exist" do
        targetformat = "awstats.%s.conf"
        conffile = ConfFile.new(nil, nil, targetformat)

        conffile.target_file.should == nil
      end
    end

  end # describe ConfFile
end # module AWStats
