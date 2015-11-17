module Geojson
  class Properties
    attr_writer :title, :description, :marker_size, :marker_symbol, :marker_color, :stroke, :stroke_opacity, :stroke_width, :fill, :fill_opacity

    def initialize(
        title: '',
        description: '',
        marker_size: 'medium',
        marker_symbol: '',
        marker_color: '#7e7e7e',
        stroke: '#555555',
        stroke_opacity: 1.0,
        stroke_width: 2.0,
        fill: '#555555',
        fill_opacity: 0.6
    )
      self.title  = title
      self.description = description
      self.marker_size = marker_size
      self.marker_symbol = marker_symbol
      self.marker_color = marker_color
      self.stroke = stroke
      self.stroke_opacity = stroke_opacity
      self.stroke_width = stroke_width
      self.fill = fill
      self.fill_opacity = fill_opacity
    end

    def title=(value)
      raise ArgumentError, 'title must be of type String' unless value.instance_of?(String)
      @title = value
    end

    def description=(value)
      raise ArgumentError, 'description must be of type String' unless value.instance_of?(String)
      @description = value
    end

    def marker_size=(value)
      @marker_size = self.class.validate_marker_size(value)
    end

    def marker_symbol=(value)
      return @marker_symbol = value if value === ''
      @marker_symbol = MapboxUtils.validate_marker_symbol(value)
    end

    def marker_color=(value)
      @marker_color = MapboxUtils.validate_color(value)
    end

    def stroke=(value)
      @stroke = MapboxUtils.validate_color(value)
    end

    def stroke_opacity=(value)
      @stroke_opacity = self.class.validate_opacity(value)
    end

    def stroke_width=(value)
      @stroke_width = self.class.validate_stroke_width(value)
    end

    def fill=(value)
      @fill = MapboxUtils.validate_color(value)
    end

    def fill_opacity=(value)
      @fill_opacity = self.class.validate_opacity(value)
    end

    def to_h
      # dont add keys with default values in order to minimize the characters sent in request
      data = Hash.new
      data[:title] = @title unless @title.empty?
      data[:description] = @description unless @description.empty?
      data[:'marker-size'] = @marker_size unless @marker_size == 'medium'
      data[:'marker-symbol'] = @marker_symbol unless @marker_symbol.empty?
      data[:'marker-color'] = @marker_color unless @marker_color == '#7e7e7e'
      data[:stroke] = @stroke unless @stroke == '#555555'
      data[:'stroke-opacity'] = @stroke_opacity unless @stroke_opacity == 1.0
      data[:'stroke-width'] = @stroke_width unless @stroke_width == 2.0
      data[:fill] = @fill unless @fill == '#555555'
      data[:'fill-opacity'] = @fill_opacity unless @fill_opacity == 0.6
      data
    end

    def self.validate_marker_size(value)
      raise ArgumentError, 'marker size must be `small`, `medium` or `large`' unless %w(small medium large).include?(value)
      value
    end

    def self.validate_opacity(value)
      raise ArgumentError, 'opacity must be between 0.0 and 1.0' unless value.is_a?(Numeric) && value >= 0.0 && value <= 1.0
      value
    end

    def self.validate_stroke_width(value)
      raise ArgumentError, 'width must be greater then or equal to 0.0' unless value.is_a?(Numeric) && value >= 0.0
      value
    end
  end
end