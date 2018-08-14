# Mapbox

Mapbox is awesome. But it doesn't have an official gem. :( So....

This the _**unofficial**_ way to connect to the [Static Map API from MapBox](http://mapbox.com/developers/api/).

This gem provides a simple way to create a static map and add markers.

## Installation

Add this line to your application's Gemfile:

    gem 'mapbox'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mapbox

## Usage

### Quick Start

Set your MAP API ID .
```
  ENV['MAPBOX_API_ID'] = "examples.map-4l7djmvo"
```

OR

```
  StaticMap.api_id = "examples.map-4l7djmvo"
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

... docs coming soon ...

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
