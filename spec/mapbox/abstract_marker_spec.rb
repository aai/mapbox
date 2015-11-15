require 'spec_helper'
require 'mapbox'

#:name-:label+:color(:lon,:lat)
#pin-s-park+cc4422(-77,38)

describe AbstractMarker do
  class Marker < AbstractMarker
    def initialize(latitude, longitude)
      self.latitude = latitude
      self.longitude = longitude
    end
  end

  context 'mixed bag of mapbox options to test validation' do
    subject(:marker) { Marker.new(lat, lon) }
    let(:lat) { '12.34567' }
    let(:lon) { 123.45678 }

    describe '#lat' do
      subject { super().lat }
      it { should == 12.34567 }
    end

    describe '#lon' do
      subject { super().lon }
      it { should == 123.45678 }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == '(123.45678,12.34567)' }
    end

    it 'should throw an exception if the latitude is malformed.' do
      expect{ subject.latitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.latitude = 86 }.to raise_error(ArgumentError)
      expect{ subject.latitude = -85.000001 }.to raise_error(ArgumentError)
    end

    it 'should throw an exception if the longitude is malformed.' do
      expect{ subject.longitude = 1337 }.to raise_error(ArgumentError)
      expect{ subject.longitude = -181 }.to raise_error(ArgumentError)
      expect{ subject.longitude = 180.000001 }.to raise_error(ArgumentError)
    end
  end

  context 'AbstractMarker class' do
    subject(:klass) { AbstractMarker }

    it 'define constanst for pin sizes' do
      expect{ subject.new }.to raise_error(RuntimeError)
    end
  end
end