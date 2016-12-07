module Exporter
  # Represents Exporto configuration
  class Settings
    DEFAULT_PATH = Rails.root.join('config', 'settings.yml').freeze

    attr_reader :raw

    def self.current
      @current ||= new(DEFAULT_PATH)
    end

    def initialize(config_path = nil)
      reader = ::Exporter::Settings::Reader.new(config_path)
      @raw = reader.read

      validate_version
    end

    def version
      raw['version'.freeze]
    end

    def mongo
      @mongo ||= ::Exporter::Settings::Mongodb.new(raw['mongo'])
    end

    def inspect
      "<#Settings: #{file.current_path}, version: #{version}>"
    end

    def validate_version
      raise "Unsupported config version '#{version}'" if version != 1
    end
  end
end
