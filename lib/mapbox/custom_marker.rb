class CustomMarker < AbstractMarker
  attr_accessor :url

  def initialize(latitude, longitude, url)
    self.latitude = latitude
    self.longitude = longitude
    self.url = url
  end

  def url=(url)
    @url = CustomMarker.encode_url(url) unless url.nil?
  end

  def to_s
    "url-#{self.url}(#{self.lon},#{self.lat})"
  end

  private

  def self.encode_url(url)
    MapboxUtils.encode_url(url)
  end

end

