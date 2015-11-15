require 'spec_helper'
require 'mapbox'

#:name-:label+:color(:lon,:lat)
#pin-s-park+cc4422(-77,38)

describe MapboxMarker do
  subject(:marker) { MapboxMarker.new(lat, lon, size) }

  let(:lat) { 38 }
  let(:lon) { -77 }
  let(:size) { MapboxMarker::SMALL_PIN }
  let(:color) { 'cc4400' }
  let(:label) { 'fire-station' }

  # Thes examples come from the MaxBox developer documentation and will be maintained
  # to match the documentation. if matching the docs causes a fail we need to look
  # if the format has changed.

  context 'with color as an RGB hex color' do
    subject(:marker) { MapboxMarker.new(lat, lon, size, label, color) }
    let(:label) { 'park' }
    let(:color) { 'cc4422' }

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s-park+cc4422(-77.0,38.0)' }
    end
  end

  context 'with a pin, small' do
    let(:size) { MapboxMarker::SMALL_PIN }

    describe '#name' do
      subject { super().name }
      it { should == 'pin-s' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s(-77.0,38.0)' }
    end
  end

  context 'with a pin, medium' do
    let(:size) { MapboxMarker::MEDIUM_PIN }

    describe '#name' do
      subject { super().name }
      it { should == 'pin-m' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-m(-77.0,38.0)' }
    end
  end

  context 'with a pin, large' do
    let(:size) { MapboxMarker::LARGE_PIN }

    describe '#name' do
      subject { super().name }
      it { should == 'pin-l' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-l(-77.0,38.0)' }
    end
  end

  context 'with a label as one of the letters from A through Z' do
    subject(:marker) { MapboxMarker.new(lat, lon, size, label) }
    let(:label) { 'a' }

    describe '#label' do
      subject { super().label }
      it { should == 'a' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s-a(-77.0,38.0)' }
    end
  end

  context 'with a label as one of the digits from 0 through 9' do
    subject(:marker) { MapboxMarker.new(lat, lon, size, label) }
    let(:label) { 5 }

    describe '#label' do
      subject { super().label }
      it { should == '5' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s-5(-77.0,38.0)' }
    end
  end

  context 'with a label as a Maki icon id' do
    subject(:marker) { MapboxMarker.new(lat, lon, size, label) }

    describe '#label' do
      subject { super().label }
      it { should == 'fire-station' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s-fire-station(-77.0,38.0)' }
    end
  end

  context 'with color as an RGB hex color' do
    subject(:marker) { MapboxMarker.new(lat, lon, size, label, color) }

    describe '#color' do
      subject { super().color }
      it { should == 'cc4400' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-s-fire-station+cc4400(-77.0,38.0)' }
    end
  end

  # These examples test some edge cases and input variations

  context 'mixed bag of mapbox options to test validation' do
    subject(:marker){ MapboxMarker.new('12.34567', 123.45678, MapboxMarker.size[:medium], 'a', '#9900cc') }

    describe '#name' do
      subject { super().name }
      it { should == MapboxMarker::MEDIUM_PIN }
    end

    describe '#size' do
      subject { super().size }
      it { should == 'pin-m' }
    end

    describe '#lat' do
      subject { super().lat }
      it { should == 12.34567 }
    end

    describe '#lon' do
      subject { super().lon }
      it { should == 123.45678 }
    end

    describe '#label' do
      subject { super().label }
      it { should == 'a' }
    end

    describe '#color' do
      subject { super().color }
      it { should == '9900cc' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'pin-m-a+9900cc(123.45678,12.34567)' }
    end

    it 'should throw an exception if the color is not correctly formatted' do
      expect{ subject.color = 'hahhah' }.to raise_error(ArgumentError)
    end

    it 'should throw an exception if the label is malformed' do
      expect{ subject.label = 10 }.to raise_error(ArgumentError)
      expect{ subject.label = '10' }.to raise_error(ArgumentError)
      expect{ subject.label = 'AA' }.to raise_error(ArgumentError)
      expect{ subject.label = 'q' }.to_not raise_error(ArgumentError)
      expect{ subject.label = 5 }.to_not raise_error(ArgumentError)
    end

    it 'should throw an exception if the label is not a maki-icon' do
      expect{ subject.label = 'wilbert' }.to raise_error(ArgumentError)
      expect{ subject.label = 'religious-agnostic' }.to raise_error(ArgumentError)
      expect{ subject.label = 'cricket' }.to_not raise_error(ArgumentError)
    end
  end

  context 'MapboxMarker class' do
    subject(:klass) { MapboxMarker }

    describe '#maki_icons' do
      subject { super().maki_icons }

      it { should include('wetland') }
      it { should include('zoo') }
      it { should include('circle-stroked') }
      it { should_not include('dangerous') }
    end

    it 'define constanst for pin sizes' do
      MapboxMarker::SMALL_PIN.should == 'pin-s'
      MapboxMarker::MEDIUM_PIN.should == 'pin-m'
      MapboxMarker::LARGE_PIN.should == 'pin-l'
    end
  end
end