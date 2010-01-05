
class Fixture
  FIXTURE_DIR = 'fixtures'
  CONFIG_NAME = 'config.yml'

  def initialize(name)
    @name = name
    @fixture_dir = File.join(File.dirname(__FILE__), FIXTURE_DIR, name)
    raise "#{@fixture_dir} does not exist!" if not File.directory? @fixture_dir
  end

  def config_stream
    conffile = File.join(@fixture_dir, CONFIG_NAME)
    raise "No config.yml file in #{@name} fixture" if not File.exist? conffile
    File.open(conffile, "r")
  end
end
