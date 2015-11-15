require 'uri'

class StaticMap

  attr_accessor :latitude, :longitude, :zoom, :width, :height, :api_id, :markers, :geojson, :params

  def initialize(latitude, longitude, zoom, width=640, height=480, api_id=nil, markers=nil)
    self.latitude = latitude
    self.longitude = longitude
    self.zoom = zoom
    self.width = width
    self.height = height
    self.api_id = api_id || StaticMap.api_id
    self.markers = markers || []
  end

  # api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/400x300.png
  # api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png
  def to_s
    base = "#{StaticMap.api_path}/#{self.api_id}/#{overlay}#{lon},#{lat},#{zoom}/#{width}x#{height}.png"
    query = params && params.length > 0 ? '?' + URI.encode_www_form(params) : ''
    base + query
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

  def latitude=(latitude)
    @latitude = MapboxUtils.validate_latitude(latitude)
  end

  def longitude=(longitude)
    @longitude = MapboxUtils.validate_longitude(longitude)
  end

  def zoom=(zoom)
    @zoom = MapboxUtils.validate_zoom(zoom)
  end

  def api_id=(api_id)
    @api_id = MapboxUtils.validate_api_id(api_id)
  end

  def params
    @params ||= self.class.version[:default_params]
  end

  def markers
    @markers ||= []
  end

  def add_marker(marker)
    self.markers << marker
  end

  def <<(marker)
    self.markers << marker
  end

  # make the overlay string from the markers, geojson or path
  def overlay
    return markers.each.map{|marker| marker.to_s}.join(',') + '/' unless markers.nil? || markers.length == 0

    return "geojson(#{URI.escape("#{geojson.to_json}")})/" unless geojson.nil? || !geojson.kind_of?(Hash)

    ''
  end

  # Allow the user to class level configure the API ID
  # defaults to reading MAPBOX_API_ID so that you can use this
  # in a very simple fashion with services like heroku

  def self.api_id
    @@api_id ||= ENV["MAPBOX_API_ID"]
  end  
  
  def self.api_id=(api_id)
    @@api_id = api_id
  end

  def self.api_path
    @@api_path ||= (ENV["MAPBOX_API_PATH"] || version[:api_path])
  end 
  
  def self.api_path=(api_path)
    @@api_path = api_path
  end

  def self.version
    token = ENV['MAPBOX_ACCESS_TOKEN']
    return { api_path: 'api.tiles.mapbox.com/v3' } unless token
    { api_path: 'api.tiles.mapbox.com/v4', default_params: { access_token: token } }
  end

end