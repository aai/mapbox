require 'cgi'
class MapboxUtils

  def self.encode_url(url)
    url.sub!(/^http[s]?\:\/\//, '')
    CGI::escape(url.to_s)
  end

  def self.validate_latitude(latitude)
    latitude = latitude.to_f
    raise ArgumentError, 'latitude needs to be between -85 and 85' unless
      latitude >= -85.0 && latitude <= 85.0 
    latitude
  end

  def self.validate_longitude(longitude)
    longitude = longitude.to_f
    raise ArgumentError, 'longitude needs to be between -180 and 180' unless
      longitude >= -180.0 && longitude <= 180.0 
    longitude
  end

  def self.validate_zoom(zoom)
    zoom = zoom.to_i
    raise ArgumentError, 'zoom needs to be between 0 and 22' unless
      zoom >= 0 && zoom <= 22 
    zoom
  end


  def self.validate_api_id(api_id)
    raise ArgumentError, 'api_id cannot be nil' if api_id.nil?
    api_id
  end

end