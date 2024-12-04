require "rails_icons/icon/attributes"

class RailsIcons::Icon
  def initialize(name:, library:, args:, variant: nil)
    @name = name
    @library = library.to_s.inquiry
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
    attributes = [
      @library,
      variant,
      @name
    ].compact_blank

    "Icon not found: `#{attributes.join(" / ")}`"
  end

  def file_path
    return RailsIcons::Engine.root.join("app", "assets", "svg", "rails_icons", "icons", "animated", "base", "#{@name}.svg") if @library.animated?
    return custom_library.dig("path") if custom_library?

    path_parts = [
      "app",
      "assets",
      "svg",
      "icons",
      @library,
      variant,
      "#{@name}.svg"
    ].compact_blank

    Rails.root.join(*path_parts)
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
    @variant.presence || ([:heroicons, :lucide, :tabler].include?(@library.to_sym) ? RailsIcons.configuration.default_variant : nil)
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
      &.dig(*variant ? [@library, variant] : [@library]) || {}
  end
end
