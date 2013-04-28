class AbstractMarker
  attr_accessor :latitude, :longitude

  def initialize(args=nil)
    raise "Cannot directly instantiate a SimpleMarker" if self.class == AbstractMarker
    super
  end

  def lat
    self.latitude
  end

  def lon
    self.longitude
  end

  def lat=(latitude)
    self.latitude = latitude
  end

  def lon=(longitude)
    self.longitude = longitude
  end

  # Override the setting methods so that they validate the input and return
  # a meaningful error message

  def latitude=(latitude)
    @latitude = MapboxUtils.validate_latitude(latitude)
  end

  def longitude=(longitude)
    @longitude = MapboxUtils.validate_longitude(longitude)
  end

  def to_s
    "(#{self.lon},#{self.lat})"
  end

end

