require 'cgi'
class MapboxUtils

  def self.maki_icons
    %w(circle-stroked circle square-stroked square triangle-stroked triangle
      star-stroked star cross marker-stroked marker religious-jewish
      religious-christian religious-muslim cemetery place-of-worship airport
      heliport rail rail-underground rail-above bus fuel parking
      parking-garage airfield roadblock ferry harbor bicycle park
      park2 museum lodging monument zoo garden campsite theatre
      art-gallery pitch soccer america-football tennis basketball baseball
      golf swimming cricket skiing school college library post
      fire-station town-hall police prison embassy waste-basket toilets
      telephone emergency-telephone disability beer restaurant cafe shop
      fast-food bar bank grocery cinema alcohol-shop music hospital
      pharmacy danger industrial warehouse commercial building oil-well
      dam slaughterhouse logging water wetland)
  end

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

  def self.validate_color(value)
    value = value[1..7] if value.start_with?('#')
    raise ArgumentError, 'color is not a hex color of the form aabbcc' unless value =~ /^[0-9a-fA-F]{6}$/
    value.downcase
    end

  def self.validate_marker_symbol(value)
    value = value.to_s
    raise ArgumentError, 'marker_symbol is either a single charater 0-9 or a-z OR a maki icon' unless
        value =~ /^[0-9a-zA-Z]$/ || MapboxUtils.maki_icons.include?(value)
    value
  end

end
