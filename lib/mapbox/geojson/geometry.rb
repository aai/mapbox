module Geojson
  # Helper class
  class Geometry
    attr_accessor :type, :coordinates

    def initialize(type: nil, coordinates: nil)
      self.type = type
      self.coordinates = coordinates
    end

    def type=(value)
      @type = self.class.validate_geometry_type(value)
    end

    def coordinates=(value)
      fail ArgumentError, 'coordinates must be of type Array' unless value.instance_of?(Array)
      @coordinates = value
    end

    def to_h
      data = {}
      data[:type] = type
      data[:coordinates] = coordinates
      data
    end

    def self.validate_geometry_type(value)
      geometry_types = %w(Point LineString Polygon MultiPoint MultiLineString MultiPolygon)
      fail ArgumentError, "type must be one of [#{geometry_types}]" unless geometry_types.include?(value)

      value
    end
  end
end
