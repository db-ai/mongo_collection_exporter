# Represents Exporto configuration
class Settings
  # Finds readable configuration file candidate and allows to read it's
  # contents.
  #
  # Used in `Exporto::Config` class.
  class File
    DEFAULT_PATH = Padrino.root("config", "settings.yml").freeze
    ENV_KEY_NAME = 'MONGO_EXPORT_CONF'.freeze

    attr_reader :current_path

    def initialize(override_path = nil)
      @override_path = override_path.freeze
      @current_path = find_config || not_found
    end

    def read
      @file_contents ||= YAML.load_file(current_path).freeze
    end

    def reset
      @file_contents = nil
      @current_path = nil
    end

    private

    def find_config
      paths.find do |path|
        next unless path
        ::File.file?(path) && ::File.readable?(path)
      end
    end

    def paths
      [@override_path, ENV[ENV_KEY_NAME], DEFAULT_PATH].compact
    end

    def not_found
      raise ArgumentError, "Failed to read config file. Tried:\n" \
                           "#{paths.join("\n")}"
    end
  end
end
