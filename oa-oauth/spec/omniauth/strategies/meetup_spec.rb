require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe OmniAuth::Strategies::Meetup do
  it_should_behave_like 'an oauth strategy'
  it 'should use the authenticate (sign in) path by default' do
    s = strategy_class.new(app, @spec)
    s.consumer_options[:authorize_path].should == 'http://www.meetup.com/authenticate'
  end

  it 'should use the authorize path if :sign_in is false' do
    s = strategy_class.new(app, @spec, :sign_in => false)
    s.consumer_options[:authorize_path].should == 'http://www.meetup.com/authorize'
  end
end
