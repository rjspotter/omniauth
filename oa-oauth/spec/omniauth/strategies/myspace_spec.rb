require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe OmniAuth::Strategies::Myspace do
  
  it 'should subclass OAuth2' do
    OmniAuth::Strategies::Myspace.should < OmniAuth::Strategies::OAuth
  end
  
  it 'should initialize with just consumer key and secret' do
    @store = double()
    @store.stub(:key) do |arg|
      if arg == :thingone
        "abc"
      else
        "someotherthingy"
      end
    end
    @store.stub(:secret) do |arg|
      if arg == :thingone
        "def"
      else
        "someotherthingy"
      end
    end
    lambda{OmniAuth::Strategies::Myspace.new({},@store)}.should_not raise_error
  end
  
end
