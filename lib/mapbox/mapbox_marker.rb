class MapboxMarker < AbstractMarker
  attr_accessor :name, :label, :color

  SMALL_PIN = 'pin-s'
  MEDIUM_PIN = 'pin-m'
  LARGE_PIN = 'pin-l'

  def self.size
    {
      :small => SMALL_PIN,
      :medium => MEDIUM_PIN,
      :large => LARGE_PIN
    }
  end

  def initialize(latitude, longitude, size = SMALL_PIN, label = nil, color = nil)
    self.name = size
    self.latitude = latitude
    self.longitude = longitude
    self.label = label
    self.color = color
  end

  def size
    self.name
  end

  def size=(size)
    self.name = size
  end

  def color=(color)
    color = color[1..7] if !color.nil? && color.start_with?('#') # remove # from color
    @color = MapboxUtils.validate_color(color) unless color.nil?
  end

  def label=(label)
    @label = MapboxUtils.validate_marker_symbol(label) unless label.nil?
  end

  def label_string
    "-#{self.label}" unless self.label.nil? || self.label.strip == ''
  end

  def color_string
    "+#{self.color}" unless self.color.nil? || self.color.strip == ''
  end

  def to_s
    "#{self.name}#{self.label_string}#{self.color_string}(#{self.lon},#{self.lat})"
  end
end

