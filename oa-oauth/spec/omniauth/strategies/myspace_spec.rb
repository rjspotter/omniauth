require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe OmniAuth::Strategies::Myspace do
  
  it 'should subclass OAuth2' do
    OmniAuth::Strategies::Myspace.should < OmniAuth::Strategies::OAuth
  end
  
  it 'should initialize with just consumer key and secret' do
    lambda{OmniAuth::Strategies::Myspace.new({},'abc','def')}.should_not raise_error
  end
  
end
