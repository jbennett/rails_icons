# frozen_string_literal: true

module RailsIcons
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Install Rails Icons with the choosen libraries. This creates the configuration initializer and will sync the icons."

    class_option :libraries, type: :array, default: [], desc: "Choose libraries (#{RailsIcons.libraries.keys.join("/")})"
    class_option :destination, type: :string, default: RailsIcons.configuration.destination_path, desc: "Specify destination folder for icons"
    class_option :skip_sync, type: :boolean, default: false

    def initializer_generator
      generate("rails_icons:initializer", *attributes)
    end

    def sync_generator
      return if options[:skip_sync] || options[:libraries].blank?

      generate("rails_icons:sync", *attributes)
    end

    private

    def attributes = ["--libraries=#{options[:libraries].join(" ")}", "--destination=#{options[:destination]}"].join(" ")
  end
end
