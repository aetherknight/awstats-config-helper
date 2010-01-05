require 'spec_helper'
require 'awstats/conf_handler'
require 'yaml'

module AWStats
  describe ConfHandler do
    context "when given a config file declaring a single domain" do
      before(:each) do
        @fixture = Fixture.new('single_domain')
        @handler = ConfHandler.new(@fixture.config_stream)
        @conf_struct = YAML::load(@fixture.config_stream)
      end

      it "should produce a single ConfFile" do
        @handler.conf_files.length.should == 1
        @handler.conf_files[0].class.should == ConfFile
      end

      it "should produce a ConfFile that matches the config.yml" do
        conffile = @handler.conf_files[0]

        @conf_struct['configs'][0]['domain'].should == conffile.domain
        @conf_struct['configs'][0]['service'].should == conffile.service
        @conf_struct['configs'][0]['aliases'].join(' ').should == conffile.aliases
        @conf_struct['configs'][0]['logfile'].should == conffile.logfile
        @conf_struct['defaults']['logformat'].should == conffile.logformat
      end

      it "should add a target config item containing the target filename" do
        conffile = @handler.conf_files[0]

        conffile.target_file.should == @conf_struct['targetformat'] % "#{conffile.service}-#{conffile.domain}"
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
        conf_struct = YAML::load(fixture.config_stream)

        handler.template.should == conf_struct['template']
      end
    end # describe #template

    describe "#generate_html_list" do
      it "should produce an html list of viewable domains from a template" do
        fixture = Fixture.new('multiple_domains')
        handler = ConfHandler.new(fixture.config_stream)
        conf_struct = YAML::load(fixture.config_stream)
        sample_file = <<-QUOTE.gsub(/^        /, '')
        <html>
        <head>
          <title>Some Title</title>
        </head>
        <body>
          <ul>
            <% conf_files.collect{|c| c.identifier}.sort.each do |s| %>
              <li><a href="/cgi-bin/awstats.pl?config=<%= s %>"><%= s %></a></li>
            <% end %>
          </ul>
        </body>
        </html>
        QUOTE

        output = handler.generate_html_list(sample_file)
        output.should match %r{<a href="/cgi-bin/awstats\.pl\?config=http-somehost">}
        output.should match %r{<a href="/cgi-bin/awstats\.pl\?config=http-anotherhost">}
        output.should match %r{<a href="/cgi-bin/awstats\.pl\?config=https-host3">}
        output.should match %r{<a href="/cgi-bin/awstats\.pl\?config=http-host4">}
      end
    end # describe #generate_html_list
  end # describe ConfHandler
end # module AWStats
