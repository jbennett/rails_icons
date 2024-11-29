require "rails_icons/icon/attributes"

class RailsIcons::Icon
  def initialize(name:, library:, variant:, args:)
    @name = name
    @library = library.to_s
    @variant = variant.to_s
    @args = args
  end

  def svg
    raise RailsIcons::NotFound, error_message unless File.exist?(file_path)

    Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))
      .at_css("svg")
      .tap { |svg| attach_attributes(to: svg) }
      .to_html
      .html_safe
  end

  private

  def error_message
    "Icon not found: `#{@library} / #{variant} / #{@name}`"
  end

  def file_path
    custom_library.dig("path") ||
      Rails.root.join("app", "assets", "svg", "icons", @library, variant, "#{@name}.svg")
  end

  def custom_library?
    custom_library.present?
  end

  def attach_attributes(to:)
    RailsIcons::Icon::Attributes
      .new(default_attributes: default_attributes, args: @args)
      .attach(to: to)
  end

  def default_attributes
    {
      "stroke-width": default_stroke_width,
      class: default_css,
      data: default_data
    }
  end

  def variant
    return @variant if @variant.present?

    RailsIcons.configuration.default_variant
  end

  def default_css
    library_set_attributes.dig(:default, :css)
  end

  def default_data
    library_set_attributes.dig(:default, :data)
  end

  def default_stroke_width
    library_set_attributes.dig(:default, :stroke_width)
  end

  def library_set_attributes
    return custom_library || {} if custom_library?

    RailsIcons.configuration.libraries.dig(@library, variant) || {}
  end

  def custom_library
    RailsIcons
      .configuration
      .libraries
      .dig("custom")
      &.with_indifferent_access
      &.dig(@library, variant) || {}
  end
end
