require 'spec_helper'
require 'awstats/conf_handler'
require 'yaml'

module AWStats
  describe ConfHandler do
    context "when given a config file declaring a single domain" do
      before(:each) do
        @fixture = Fixture.new('single_domain')
        @handler = ConfHandler.new(@fixture.config_stream)
      end

      it "should produce a single ConfFile" do
        @handler.conf_files.length.should == 1
        @handler.conf_files[0].class.should == ConfFile
      end

      it "should produce a ConfFile that matches the config.yml" do
        conf_stream = @fixture.config_stream
        conf_struct = YAML::load(conf_stream)

        conffile = @handler.conf_files[0]

        conf_struct['configs'][0]['domain'].should == conffile.domain
        conf_struct['configs'][0]['service'].should == conffile.service
        conf_struct['configs'][0]['aliases'].join(' ').should == conffile.aliases
        conf_struct['configs'][0]['logfile'].should == conffile.logfile
        conf_struct['defaults']['logformat'].should == conffile.logformat
      end
    end


    context "when given a config file declaring multiple domains" do
      before(:each) do
        @fixture = Fixture.new('multiple_domains')
        @handler = ConfHandler.new(@fixture.config_stream)
      end

      it "should produce a list of several ConfFiles" do
        @handler.conf_files.length.should == 4
        @handler.conf_files.each_index do |i|
          @handler.conf_files[i].class.should == ConfFile
        end
      end
    end

    describe "#template" do
      it "should return a template filename based on the template config setting" do
        fixture = Fixture.new('multiple_domains')
        handler = ConfHandler.new(fixture.config_stream)
        conf_stream = fixture.config_stream
        conf_struct = YAML::load(conf_stream)

        handler.template.should == conf_struct['template']
      end
    end # describe #template
  end # describe ConfHandler
end # module AWStats
