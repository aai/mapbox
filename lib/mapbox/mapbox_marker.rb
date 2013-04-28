class MapboxMarker < AbstractMarker
  attr_accessor :name, :label, :color

  SMALL_PIN = "pin-s"
  MEDIUM_PIN = "pin-m"
  LARGE_PIN = "pin-l"

  def self.size
    {
      :small => SMALL_PIN,
      :medium => MEDIUM_PIN,
      :large => LARGE_PIN
    }
  end

  def self.maki_icons
    [ "circle-stroked", "circle", "square-stroked", "square", "triangle-stroked", "triangle", 
      "star-stroked", "star", "cross", "marker-stroked", "marker", "religious-jewish", 
      "religious-christian", "religious-muslim", "cemetery", "place-of-worship", "airport", 
      "heliport", "rail", "rail-underground", "rail-above", "bus", "fuel", "parking", 
      "parking-garage", "airfield", "roadblock", "ferry", "harbor", "bicycle", "park", 
      "park2", "museum", "lodging", "monument", "zoo", "garden", "campsite", "theatre", 
      "art-gallery", "pitch", "soccer", "america-football", "tennis", "basketball", "baseball", 
      "golf", "swimming", "cricket", "skiing", "school", "college", "library", "post", 
      "fire-station", "town-hall", "police", "prison", "embassy", "waste-basket", "toilets", 
      "telephone", "emergency-telephone", "disability", "beer", "restaurant", "cafe", "shop", 
      "fast-food", "bar", "bank", "grocery", "cinema", "alcohol-shop", "music", "hospital", 
      "pharmacy", "danger", "industrial", "warehouse", "commercial", "building", "oil-well", 
      "dam", "slaughterhouse", "logging", "water", "wetland" ]
  end

  def initialize(latitude, longitude, size=SMALL_PIN, label=nil, color=nil)
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
    @color = MapboxMarker.validate_color(color) unless color.nil?
  end

  def label=(label)
    @label = MapboxMarker.validate_label(label) unless label.nil?
  end

  def label_string
    "-#{self.label}" unless self.label.nil? || self.label.strip == ""
  end

  def color_string
    "+#{self.color}" unless self.color.nil? || self.color.strip == ""
  end

  def to_s
    "#{self.name}#{self.label_string}#{self.color_string}(#{self.lon},#{self.lat})"
  end

  private

  def self.validate_color(color)
    color = color[1..7] if color.start_with?("#")
    raise ArgumentError, "color is not a hex color of the form aabbcc" unless color =~ /^[0-9a-fA-F]{6}$/
    color.downcase
  end

  def self.validate_label(label)
    label = label.to_s
    raise ArgumentError, "a label is either a single charater 0-9 or a-z OR a maki icon" unless 
      label =~ /^[0-9a-zA-Z]{1}$/ || MapboxMarker.maki_icons.include?(label)
    label
  end
end

