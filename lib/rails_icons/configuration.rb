# frozen_string_literal: true

require_relative "configuration/animated"
require_relative "configuration/feather"
require_relative "configuration/heroicons"
require_relative "configuration/lucide"
require_relative "configuration/phosphor"
require_relative "configuration/tabler"

module RailsIcons
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    def initialize
      @config = ActiveSupport::OrderedOptions.new

      set_default_config
      set_libraries_config
    end

    def method_missing(method_name, ...)
      if @config.respond_to?(method_name)
        @config.send(method_name, ...)
      else
        super
      end
    end

    def respond_to_missing?(method_name)
      @config.respond_to?(method_name) || super
    end

    private

    def set_default_config
      @config.default_library = nil
      @config.destination_path = "app/assets/svg/icons"
    end

    def set_libraries_config
      @config.libraries = ActiveSupport::OrderedOptions.new

      RailsIcons.libraries.each { |name, library| @config.libraries[name] = library.config }

      @config.libraries.animated = Configuration::Animated.config
    end
  end
end
