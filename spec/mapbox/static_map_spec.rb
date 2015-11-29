require 'spec_helper'
require 'mapbox'


# /:map/:lon,:lat,:z/:widthx:height.png
# api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/400x300.png

# /:map/:markers/:lon,:lat,:z/:widthx:height.png
# api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png

describe StaticMap do
  subject(:map) { StaticMap.new(lat, lon, zoom, width, height, api_id) }
  let(:lat) {38.89}
  let(:lon) {-77.04}
  let(:zoom) {13}
  let(:width) {400}
  let(:height) {300}
  let(:api_id) { 'examples.map-4l7djmvo' }
  let(:token) { 'pk.RtaW4iLCJhIjoid1ZLYXc2WSJ9.3K_mHa' }

  before do
    # clear out the cache
    StaticMap.api_path = nil
    StaticMap.api_id = nil
    StaticMap.access_token = nil
  end

  context 'static image for :map' do
    subject(:map) { StaticMap.new(lat, lon, zoom, width, height, api_id, markers) }
    let(:expected_version) { 3 }
    let(:expected_base_url) { "api.tiles.mapbox.com/v#{expected_version}/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png" }
    let(:markers){ [MapboxMarker.new(38.89,-77.04, MapboxMarker::MEDIUM_PIN, 'monument')] }

    describe '#to_s' do
      subject { super().to_s }
      it { should == expected_base_url }
    end

    context 'extra params' do
      before do
        map.params = { foo: 'hello world' }
      end

      describe '#to_s' do
        subject { super().to_s }
        it { should == "#{expected_base_url}?foo=hello+world" }
      end
    end

    context 'default v4 params' do
      let(:expected_version) { 4 }

      before do
        allow(ENV).to receive(:[]).with('MAPBOX_API_PATH').and_return nil
        allow(ENV).to receive(:[]).with('MAPBOX_ACCESS_TOKEN').and_return token
      end

      describe '#to_s' do
        subject { super().to_s }
        it { should == "#{expected_base_url}?access_token=#{token}" }
      end
    end
  end

  context 'Static image for :map with :markers' do
    describe '#to_s' do
      subject { super().to_s }
      it { should == 'api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/400x300.png' }
    end

    it 'should add markers to itself' do
      subject << MapboxMarker.new(38.89,-77.04, MapboxMarker::MEDIUM_PIN, 'monument')

      expect(subject.to_s).to eq('api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png')
    end
  end

  context 'Static image for :map with :geojson' do
    subject(:map) { StaticMap.new(lat, lon, zoom, width, height, api_id) }
    let(:lat) { 12.51000 }
    let(:lon) { -69.95000 }
    let(:zoom) { 12 }
    let(:properties) { Geojson::Properties.new(stroke_width: 4, stroke: '#ff4444', stroke_opacity: 0.5) }
    let(:geometry) { Geojson::Geometry.new(type: 'Polygon', coordinates: [[[-69.89912109375001,12.452001953124963],[-70.05087890624995,12.597070312500037],[-69.97314453125,12.567626953124986],[-69.89912109375001,12.452001953124963]]]) }
    let(:geojson) { Geojson::Base.new(properties: properties, geometry: geometry) }

    before do
      allow(ENV).to receive(:[]).with('MAPBOX_API_PATH').and_return nil
      allow(ENV).to receive(:[]).with('MAPBOX_ACCESS_TOKEN').and_return token
    end

    it 'has geojson in url' do
      map.geojson = geojson
      geojson_encoded = URI.escape("#{geojson.to_json}").gsub("[","%5B").gsub("]","%5D")

      expect(map.to_s).to eq("api.tiles.mapbox.com/v4/examples.map-4l7djmvo/geojson(#{geojson_encoded})/-69.95,12.51,12/400x300.png?access_token=#{token}")
    end
  end

  context 'api path' do
    subject { StaticMap.api_path }

    describe 'no environment variable' do
      it { should == 'api.tiles.mapbox.com/v3' }
    end

    context 'environment variables' do
      before do
        allow(ENV).to receive(:[]).with('MAPBOX_API_PATH').and_return api_path
      end

      context 'MAPBOX_API_PATH environment variable' do
        let(:api_path) { 'my.custom.host/version' }

        it { should == api_path }
      end

      context 'MAPBOX_ACCESS_TOKEN environment variable' do
        let(:api_path) { nil }

        before do
          allow(ENV).to receive(:[]).with('MAPBOX_ACCESS_TOKEN').and_return token
        end

        it { should == 'api.tiles.mapbox.com/v4' }
      end
    end
  end

  context 'Testing input validation' do
    it 'should throw an exception without an api_id' do
      expect{ subject.api_id = nil }.to raise_error(ArgumentError)
    end

    it 'should throw an exception if the latitude is malformed' do
      expect{ subject.latitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.latitude = 86 }.to raise_error(ArgumentError)
      expect{ subject.latitude = -85.000001 }.to raise_error(ArgumentError)
    end

    it 'should throw an exception if the longitude is malformed' do
      expect{ subject.longitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.longitude = -181 }.to raise_error(ArgumentError)
      expect{ subject.longitude = 180.000001 }.to raise_error(ArgumentError)
    end

    it 'should throw an exception if the zoom is malformed' do
      expect{ subject.zoom = -1 }.to raise_error(ArgumentError)
      expect{ subject.zoom = 23 }.to raise_error(ArgumentError)
      expect{ subject.zoom = 22 }.not_to raise_error
      expect{ subject.zoom = 0 }.not_to raise_error
    end
  end
end