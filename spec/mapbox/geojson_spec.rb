require 'spec_helper'
require 'mapbox'

describe Geojson do
  context 'Base' do
    let(:properties) { Geojson::Properties.new(title: 'Hello', stroke: '#ff4444') }
    let(:geometry) { Geojson::Geometry.new(type: 'Point', coordinates: [0, 0]) }

    describe '.initialize' do
      it 'should not throw exception' do
        expect{ Geojson::Base.new(properties: properties, geometry: geometry) }.to_not raise_error
      end

      it 'should validate properties' do
        expect{ Geojson::Base.new(properties: nil, geometry: geometry) }.to raise_error(ArgumentError)
      end

      it 'should validate geometry' do
        expect{ Geojson::Base.new(properties: properties, geometry: nil) }.to raise_error(ArgumentError)
      end
    end

    describe '#to_json' do
      it 'should return json' do
        geojson = Geojson::Base.new(properties: properties, geometry: geometry)
        expect( geojson.to_json ).to eq('{"type":"Feature","properties":{"title":"Hello","stroke":"#ff4444"},"geometry":{"type":"Point","coordinates":[0,0]}}')
      end

      it 'should return json without properties' do
        geojson = Geojson::Base.new(properties: Geojson::Properties.new, geometry: geometry)
        expect( geojson.to_json ).to eq('{"type":"Feature","geometry":{"type":"Point","coordinates":[0,0]}}')
      end
    end
  end

  context 'Geometry' do
    describe '.initialize' do
      it 'should not throw exception' do
        expect{ Geojson::Geometry.new(type: 'Point', coordinates: [0, 0]) }.to_not raise_error
      end

      it 'should validate geometry type' do
        expect{ Geojson::Geometry.new(type: 'NotAType', coordinates: [0, 0]) }.to raise_error(ArgumentError)
      end

      it 'should validate geometry coordinates' do
        expect{ Geojson::Geometry.new(type: 'Point', coordinates: 'wrong coordinates') }.to raise_error(ArgumentError)
      end
    end

    describe '#to_json' do
      subject(:geometry) { Geojson::Geometry.new(type: 'Point', coordinates: [0, 0]) }

      it 'should return hash' do
        expect( geometry.to_h ).to eq({type: 'Point', coordinates: [0, 0]})
      end

      it 'should change parameters after init and return hash' do
        geometry.type = 'LineString'
        geometry.coordinates = [[0, 0], [1, 1]]

        expect( geometry.to_h ).to eq({type: 'LineString', coordinates: [[0, 0], [1, 1]]})
      end
    end
  end

  context 'Properties' do
    describe '.initialize' do
      it 'should not throw exception' do
        expect{ Geojson::Properties.new }.to_not raise_error
      end

      it 'should validate title' do
        expect{ Geojson::Properties.new(title: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate description' do
        expect{ Geojson::Properties.new(description: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate marker_size' do
        expect{ Geojson::Properties.new(marker_size: 'big') }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(marker_size: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate marker_symbol' do
        expect{ Geojson::Properties.new(marker_symbol: 'not-a-marker') }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(marker_symbol: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate marker_color' do
        expect{ Geojson::Properties.new(marker_color: 'red') }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(marker_color: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate stroke' do
        expect{ Geojson::Properties.new(stroke: 'red') }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(stroke: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate stroke_opacity' do
        expect{ Geojson::Properties.new(stroke_opacity: -4) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(stroke_opacity: 2) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(stroke_opacity: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate stroke_width' do
        expect{ Geojson::Properties.new(stroke_width: -4) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(stroke_width: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate stroke_width' do
        expect{ Geojson::Properties.new(stroke_width: -4) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(stroke_width: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate fill' do
        expect{ Geojson::Properties.new(fill: 'red') }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(fill: Array.new) }.to raise_error(ArgumentError)
      end

      it 'should validate fill_opacity' do
        expect{ Geojson::Properties.new(fill_opacity: -4) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(fill_opacity: 2) }.to raise_error(ArgumentError)
        expect{ Geojson::Properties.new(fill_opacity: Array.new) }.to raise_error(ArgumentError)
      end
    end

    describe '#to_json' do
      it 'should return empty hash' do
        properties = Geojson::Properties.new
        expect( properties.to_h ).to eq({})
      end

      it 'should return hash with title' do
        properties = Geojson::Properties.new(title: 'hello')
        expect( properties.to_h ).to eq({ title: 'hello' })
      end

      it 'should return hash with mixed data' do
        properties = Geojson::Properties.new(title: 'hello', marker_size: 'large', stroke_width: 4, stroke_opacity: 0.8)
        expect( properties.to_h ).to eq({ title: 'hello', :'marker-size' => 'large', :'stroke-width' => 4.0, :'stroke-opacity' => 0.8 })
      end
    end
  end
end
