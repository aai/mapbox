require 'spec_helper'
require 'mapbox'

#:name-:label+:color(:lon,:lat)
#pin-s-park+cc4422(-77,38)

describe MapboxMarker do
  subject(:marker){ MapboxMarker.new(lat, lon, size) }

  let(:lat){ 38 }
  let(:lon){ -77 }
  let(:size){ MapboxMarker::SMALL_PIN }
  let(:color){ "cc4400" }
  let(:label){ "fire-station" }

  # Thes examples come from the MaxBox developer documentation and will be maintained
  # to match the documentation. if matching the docs causes a fail we need to look
  # if the format has changed.

  context "with color as an RGB hex color" do
    subject(:marker){ MapboxMarker.new(lat, lon, size, label, color) }
    let(:label){ "park" }
    let(:color){ "cc4422" }

    its(:to_s){ should == "pin-s-park+cc4422(-77.0,38.0)" }
  end

  context "with a pin, small" do
    let(:size){ MapboxMarker::SMALL_PIN }

    its(:name){ should == "pin-s" }
    its(:to_s){ should == "pin-s(-77.0,38.0)" }
  end

  context "with a pin, medium" do
    let(:size){ MapboxMarker::MEDIUM_PIN }

    its(:name){ should == "pin-m" }
    its(:to_s){ should == "pin-m(-77.0,38.0)" }
  end

  context "with a pin, large" do
    let(:size){ MapboxMarker::LARGE_PIN }

    its(:name){ should == "pin-l" }
    its(:to_s){ should == "pin-l(-77.0,38.0)" }
  end

  context "with a label as one of the letters from A through Z" do
    subject(:marker){ MapboxMarker.new(lat, lon, size, label) }
    let(:label){ "a" }

    its(:label){ should == "a" }
    its(:to_s){ should == "pin-s-a(-77.0,38.0)" }
  end

  context "with a label as one of the digits from 0 through 9 " do
    subject(:marker){ MapboxMarker.new(lat, lon, size, label) }
    let(:label){ 5 }

    its(:label){ should == "5" }
    its(:to_s){ should == "pin-s-5(-77.0,38.0)" }
  end

  context "with a label as a Maki icon id" do
    subject(:marker){ MapboxMarker.new(lat, lon, size, label) }

    its(:label){ should == "fire-station" }
    its(:to_s){ should == "pin-s-fire-station(-77.0,38.0)" }
  end

  context "with color as an RGB hex color" do
    subject(:marker){ MapboxMarker.new(lat, lon, size, label, color) }

    its(:color){ should == "cc4400" }
    its(:to_s){ should == "pin-s-fire-station+cc4400(-77.0,38.0)" }
  end

  # These examples test some edge cases and input variations

  context "mixed bag of mapbox options to test validation" do     
    subject(:marker){ MapboxMarker.new("12.34567", 123.45678, MapboxMarker.size[:medium], "a", "#9900cc") }

    its(:name){ should == MapboxMarker::MEDIUM_PIN }
    its(:size){ should == "pin-m" }
    its(:lat){ should == 12.34567 }
    its(:lon){ should == 123.45678 }
    its(:label){ should == "a" }
    its(:color){ should == "9900cc" }

    its(:to_s){ should == "pin-m-a+9900cc(123.45678,12.34567)" }

    it "should throw an exception if the color is not correctly formatted." do
      expect{ subject.color = "hahhah" }.to raise_error(ArgumentError)
    end

    it "should throw an exception if the label is malformed." do
      expect{ subject.label = 10 }.to raise_error(ArgumentError)
      expect{ subject.label = "10" }.to raise_error(ArgumentError)
      expect{ subject.label = "AA" }.to raise_error(ArgumentError)
      expect{ subject.label = "q" }.to_not raise_error(ArgumentError)
      expect{ subject.label = 5 }.to_not raise_error(ArgumentError)
    end

    it "should throw an exception if the label is not a maki-icon." do
      expect{ subject.label = "wilbert" }.to raise_error(ArgumentError)
      expect{ subject.label = "religious-agnostic" }.to raise_error(ArgumentError)
      expect{ subject.label = "cricket" }.to_not raise_error(ArgumentError)
    end
  end

  context "MapboxMarker class" do
    subject(:klass) { MapboxMarker }

    its(:maki_icons){ should include("wetland") }
    its(:maki_icons){ should include("zoo") }
    its(:maki_icons){ should include("circle-stroked") }
    its(:maki_icons){ should_not include("dangerous") }

    it "define constanst for pin sizes" do 
      MapboxMarker::SMALL_PIN.should == "pin-s"
      MapboxMarker::MEDIUM_PIN.should == "pin-m"
      MapboxMarker::LARGE_PIN.should == "pin-l"
    end
  end
end