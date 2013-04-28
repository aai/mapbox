require 'spec_helper'
require 'mapbox'


# /:map/:lon,:lat,:z/:widthx:height.png
# api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/400x300.png

# /:map/:markers/:lon,:lat,:z/:widthx:height.png
# api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png

describe StaticMap do
  subject(:map){ StaticMap.new(lat, lon, zoom, width, height, api_id) }
  let(:lat){38.89}
  let(:lon){-77.04}
  let(:zoom){13}
  let(:width){400}
  let(:height){300}
  let(:api_id){"examples.map-4l7djmvo"}

  context "static image for :map" do
    subject(:map){ StaticMap.new(lat, lon, zoom, width, height, api_id, markers) }
    let(:markers){ [MapboxMarker.new(38.89,-77.04,MapboxMarker::MEDIUM_PIN,"monument")] }
    its(:to_s){should == "api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png" }
  end

  context "Static image for :map with :markers" do
    its(:to_s){should == "api.tiles.mapbox.com/v3/examples.map-4l7djmvo/-77.04,38.89,13/400x300.png" }

    it "should add markers to itself" do
      subject << MapboxMarker.new(38.89,-77.04,MapboxMarker::MEDIUM_PIN,"monument")

      subject.to_s.should == 
        "api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-m-monument(-77.04,38.89)/-77.04,38.89,13/400x300.png"
    end
  end

  context "Testing input validation" do
    it "should throw an exception without an api_id." do
      expect{ subject.api_id = nil }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the latitude is malformed." do
      expect{ subject.latitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.latitude = 86 }.to raise_error(ArgumentError)
      expect{ subject.latitude = -85.000001 }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the longitude is malformed." do
      expect{ subject.longitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.longitude = -181 }.to raise_error(ArgumentError)
      expect{ subject.longitude = 180.000001 }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the zoom is malformed." do
      expect{ subject.zoom = -1 }.to raise_error(ArgumentError)
      expect{ subject.zoom = 23 }.to raise_error(ArgumentError)
      expect{ subject.zoom = 22 }.not_to raise_error(ArgumentError)
      expect{ subject.zoom = 0 }.not_to raise_error(ArgumentError)
    end
  end
end