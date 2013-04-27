require 'spec_helper'
require 'mapbox'

#:name-:label+:color(:lon,:lat)
#pin-s-park+cc4422(-77,38)

describe MapboxMarker do
  context "mixed bag of mapbox options to test validation" do 
    subject(:marker){ MapboxMarker.new("12.34567", 123.45678, MapboxMarker.size[:medium], "label", "#9900cc") }

    its(:name){ should == MapboxMarker::MEDIUM_PIN }
    its(:size){ should == "pin-m" }
    its(:lat){ should == 12.34567 }
    its(:lon){ should == 123.45678 }
    its(:label){ should == "label" }
    its(:color){ should == "9900cc" }

    its(:to_s){ should == "pin-m-label+9900cc(12.34567,123.45678)" }


    it "should throw an exception if the color is not correctly formatted." do
      expect{ subject.color = "hahhah" }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the latitude is malformed." do
      expect{ subject.latitude = 1337 }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the longitude is malformed." do
      expect{ subject.longitude = 1337 }.to raise_error(ArgumentError)
    end
  end
end