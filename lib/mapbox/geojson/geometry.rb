module Geojson
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
      raise ArgumentError, 'coordinates must be of type Array' unless value.instance_of?(Array)
      @coordinates = value
    end

    def to_h
      data = Hash.new
      data[:type] = self.type
      data[:coordinates] = self.coordinates
      data
    end

    def self.validate_geometry_type(value)
      geometry_types = %w(Point LineString Polygon MultiPoint MultiLineString MultiPolygon)
      raise ArgumentError, "type must be one of [#{geometry_types.to_s}]" unless geometry_types.include?(value)
      value
    end
  end
end