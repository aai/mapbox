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
  let(:api_id) {'examples.map-4l7djmvo'}

  before do
    StaticMap.api_path = nil # clear out the cache
  end

  context 'static image for :map' do
    subject(:map) { StaticMap.new(lat, lon, zoom, width, height, api_id, markers) }
    let(:expected_version) { 3 }
    let(:expected_base_url) { "api.tiles.mapbox.com/v#{expected_version}/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png" }
    let(:markers){ [MapboxMarker.new(38.89,-77.04, MapboxMarker::MEDIUM_PIN, 'monument')] }
    let(:token) { 'pk.RtaW4iLCJhIjoid1ZLYXc2WSJ9.3K_mHa' }

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

      subject.to_s.should == 'api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png'
    end
  end

  describe 'api path' do
    subject { StaticMap.api_path }

    context 'no environment variable' do
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
        let(:token) { 'eea3d0b84.134ce8bf75' }
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
      expect{ subject.zoom = 22 }.not_to raise_error(ArgumentError)
      expect{ subject.zoom = 0 }.not_to raise_error(ArgumentError)
    end
  end
end