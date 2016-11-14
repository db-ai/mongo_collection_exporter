# Represents Exporto configuration
class Settings
  attr_reader :raw

  def self.current
    @current ||= new
  end

  def initialize(config_path = nil)
    @file = Settings::File.new(config_path)
    @raw = @file.read

    validate_version
  end

  def version
    raw['version'.freeze]
  end

  def mongo
    @mongo ||= Settings::Mongo.new(raw['mongo'])
  end

  def inspect
    "<#Settings: #{file.current_path}, version: #{version}>"
  end

  def validate_version
    raise "Unsupported config version #{version}" if version != 1
  end
end
