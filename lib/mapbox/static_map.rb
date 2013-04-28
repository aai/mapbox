class StaticMap 

  attr_accessor :latitude, :longitude, :zoom, :width, :height, :api_id, :markers

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
    "#{StaticMap.api_path}/#{self.api_id}/#{marker_string}#{lon},#{lat},#{zoom}/#{width}x#{height}.png"
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

  def markers
    @markers ||= []
  end

  def add_marker(marker)
    self.markers << marker
  end

  def <<(marker)
    self.markers << marker
  end
  # make the string from the markers

  def marker_string
    markers.each.map{|marker| marker.to_s}.join(",") + "/" unless markers.nil? or markers.empty?
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
    @@api_path ||= (ENV["MAPBOX_API_PATH"] || "api.tiles.mapbox.com/v3")
  end 
  
  def self.api_path=(api_path)
    @@api_path = api_path
  end

end