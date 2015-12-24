# Geojson helper module for spec
# https://github.com/mapbox/simplestyle-spec/tree/master/1.1.0
# Geojson format definition http://geojson.org/

module Geojson
  # Main class
  class Base
    attr_writer :properties, :geometry

    def initialize(properties: nil, geometry: nil)
      self.properties = properties
      self.geometry = geometry
    end

    def properties=(value)
      fail ArgumentError, 'geometry must be an instance of Geojson::Geometry' unless value.instance_of?(Geojson::Properties)
      @properties = value
    end

    def geometry=(value)
      fail ArgumentError, 'geometry must be an instance of Geojson::Geometry' unless value.instance_of?(Geojson::Geometry)
      @geometry = value
    end

    def to_json
      properties_hash = @properties.to_h

      data = {}
      data[:type] = 'Feature'
      data[:properties] = properties_hash unless properties_hash.empty?
      data[:geometry] = @geometry.to_h
      data.to_json
    end
  end
end
