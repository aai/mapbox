# Mapbox

Mapbox is awesome. But it doesn't have an official gem. :( So....

This the the _**unofficial**_ way to connect to the [Static Map API from MapBox](http://mapbox.com/developers/api/).

This gem provides a simple way to create a static map and add markers.

## Installation

Add this line to your application's Gemfile:

    gem 'mapbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mapbox

## Usage

### Quick Start (Mapbox API *V3*)

Set your MAP API ID .

```ruby
    ENV['MAPBOX_API_ID'] = 'examples.map-4l7djmvo'
```

OR

```ruby
    StaticMap.api_id = 'examples.map-4l7djmvo'
```

### Quick Start (Mapbox API *V4*)

Set your MAP API ID .

```ruby
    ENV['MAPBOX_API_ID'] = 'examples.map-4l7djmvo'
    ENV['MAPBOX_ACCESS_TOKEN'] = 'pk.RtaW4iLCJhIjoid1ZLYXc2WSJ9.3K_mHa'
```

OR

```ruby
    StaticMap.api_id = 'examples.map-4l7djmvo'
    StaticMap.api_token = 'pk.RtaW4iLCJhIjoid1ZLYXc2WSJ9.3K_mHa'
```

Make a map.

```ruby
    # StaticMap.new(lat, lon, zoom, width=640, height=480)
    map = StaticMap.new(38.89,-77.04,13)
    map.width = 400
    map.width = 300
    map.to_s
    # => "api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/300x480.png"
```

Add markers.

```ruby
    # MapboxMarker.new(latitude, longitude, size=SMALL_PIN, label=nil, color=nil)
    map << MapboxMarker.new(38.89, -77.04, MapboxMarker::MEDIUM_PIN, "monument")
    map.to_s
    # => "api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/300x480.png"
```

### StaticMap

Static map with geojson overlay

```ruby
    coordinates = [[[-69.89912109375001,12.452001953124963],[-70.05087890624995,12.597070312500037],[-69.97314453125,12.567626953124986],[-69.89912109375001,12.452001953124963]]]
    geojson_properties = Geojson::Properties.new(stroke_width: 4, stroke: '#ff4444', stroke_opacity: 0.5)
    geojson_geometry = Geojson::Geometry.new(type: 'Polygon', coordinates: coordinates)
    geojson = Geojson::Base.new(properties: geojson_properties, geometry: geojson_geometry)
    StaticMap.api_id = 'mapbox.streets-satellite'
    map = StaticMap.new(12.51, -69.95,12, 12)
    map.width = 1280
    map.height = 800
    map.geojson = geojson
    map.to_s
    # => "api.tiles.mapbox.com/v4/mapbox.streets-satellite/geojson(%7B%22type%22:%22Feature%22,%22properties%22:%7B%22stroke-width%22:4,%22stroke%22:%22%23ff4444%22,%22stroke-opacity%22:0.5%7D,%22geometry%22:%7B%22type%22:%22Polygon%22,%22coordinates%22:[[[-69.89912109375001,12.452001953124963],[-70.05087890624995,12.597070312500037],[-69.97314453125,12.567626953124986],[-69.89912109375001,12.452001953124963]]]%7D%7D)/-69.95,12.51,12/1280x800.png?access_token=pk.RtaW4iLCJhIjoid1ZLYXc2WSJ9.3K_mHa"
```

### MapboxMarker

... docs coming soon ...

### CustomMarker

... docs coming soon ...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
