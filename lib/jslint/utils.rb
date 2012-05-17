require 'fileutils'
require 'yaml'

module JSLint

  VERSION = "1.1.1"
  DEFAULT_CONFIG_FILE = File.expand_path(File.dirname(__FILE__) + "/config/jslint.yml")

  class << self
    attr_writer :config_path

    def config_path
      @config_path || JSLint::Utils.default_config_path
    end
  end

  module Utils
    class << self
      def in_rails?
        defined?(Rails)
      end

      def default_config_path
        if in_rails?
          File.expand_path(File.join(Rails.root, 'config', 'jslint.yml'))
        else
          'config/jslint.yml'
        end
      end

      def display(txt)
        print txt
      end

      def log(txt)
        puts txt
      end

      def pluralize(amount, word)
        s = "s" unless amount == 1
        "#{amount} #{word}#{s}"
      end

      def load_config_file(file_name)
        if file_name && File.exists?(file_name) && File.file?(file_name) && File.readable?(file_name)
          YAML.load_file(file_name)
        else
          {}
        end
      end

      # workaround for a problem with case-insensitive file systems like HFS on Mac
      def unique_files(list)
        files = []
        list.each do |entry|
          files << entry unless files.any? { |f| File.identical?(f, entry) }
        end
        files
      end

      # workaround for a problem with case-insensitive file systems like HFS on Mac
      def exclude_files(list, excluded)
        list.reject { |entry| excluded.any? { |f| File.identical?(f, entry) }}
      end

      def paths_from_command_line(field)
        argument = ENV[field] || ENV[field.upcase]
        argument && argument.split(/,/)
      end
    end
  end
end
