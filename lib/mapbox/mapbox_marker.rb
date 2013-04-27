class MapboxMarker
  attr_accessor :name, :latitude, :longitude, :label, :color

  SMALL_PIN = "pin-s"
  MEDIUM_PIN = "pin-m"
  LARGE_PIN = "pin-l"

  def self.size
    {
      small: SMALL_PIN,
      medium: MEDIUM_PIN,
      large: LARGE_PIN
    }
  end

  def initialize(latitude, longitude, size=MEDIUM_PIN, label=nil, color=nil)
    self.name = size
    self.latitude = latitude
    self.longitude = longitude
    self.label = label
    self.color = color
  end

  def latitude=(latitude)
    @latitude = MapboxMarker.validate_latitude(latitude)
  end

  def longitude=(longitude)
    @longitude = MapboxMarker.validate_longitude(longitude)
  end

  def lat
    self.latitude
  end

  def lon
    self.longitude
  end

  def size
    self.name
  end

  def size=(size)
    self.name = size
  end

  def lat=(latitude)
    self.latitude = latitude
  end

  def lon=(longitude)
    self.longitude = longitude
  end

  def color=(color)
    @color = MapboxMarker.validate_color(color) unless color.nil?
  end

  def label_string
    "-#{self.label}" unless self.label.nil? || self.label.strip == ""
  end

  def color_string
    "+#{self.color}" unless self.label.nil? || self.label.strip == ""
  end

  # :name-:label+:color(:lon,:lat)
  # pin-s-park+cc4422(-77,38)
  def to_s
    "#{self.name}#{self.label_string}#{self.color_string}(#{self.lat},#{self.lon})"
  end

  private

  def self.validate_color(color)
    color = color[1..7] if color.start_with?("#")
    raise ArgumentError, "color is not a hex color of the form aabbcc" unless color =~ /^[0-9a-fA-F]{6}$/
    color.downcase
  end

  def self.validate_latitude(latitude)
    latitude = latitude.to_f
    raise ArgumentError, "latitude needs to be between -90 and 90" unless 
      latitude >= -90.0 && latitude <= 90.0 
    latitude
  end

  def self.validate_longitude(longitude)
    longitude = longitude.to_f
    raise ArgumentError, "longitude needs to be between -180 and 180" unless 
      longitude >= -180.0 && longitude <= 180.0 
    longitude
  end
end

