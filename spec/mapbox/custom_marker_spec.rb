require 'spec_helper'
require 'mapbox'

#:name-:label+:color(:lon,:lat)
#pin-s-park+cc4422(-77,38)

describe CustomMarker do
  subject(:marker) { CustomMarker.new(lat, lon, url) }

  let(:lat) { 38 }
  let(:lon) { -77 }
  let(:url) { 'http://bit.ly/KahHBj' }

  # These examples come from the MaxBox developer documentation and will be maintained
  # to match the documentation. if matching the docs causes a fail we need to look
  # if the format has changed.

  context 'with external marker image at :url' do
    describe '#url' do
      subject { super().url }
      it { should == 'bit.ly%2FKahHBj' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'url-bit.ly%2FKahHBj(-77.0,38.0)' }
    end
  end

  # These examples test some edge cases and input variations

  context 'mixed bag of mapbox options to test validation' do
    let(:url) { 'm.anml.io/image/1233456' }

    describe '#url' do
      subject { super().url }
      it { should == 'm.anml.io%2Fimage%2F1233456' }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { should == 'url-m.anml.io%2Fimage%2F1233456(-77.0,38.0)' }
    end
  end
end