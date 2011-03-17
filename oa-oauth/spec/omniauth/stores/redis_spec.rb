require 'spec_helper'
require 'ostruct'

describe 'OmniAuth::Stores::Redis' do

  context "configuring and creating" do

    before do
      ::Redis  = double()
      @redis = double()
      @redis.stub(:class).and_return ::Redis
    end

    it "should take a Redis Client as a first argument" do
      expect {OmniAuth::Stores::Redis.new(@redis)}.should_not raise_error
    end

    it "should take a connection string as a first arg" do
      pending "connection massager"
    end

    it "should take a connection config hash as a first arg" do
      pending "connection massager"
    end    

    it "should fail if first arg is wrong" do
      expect {OmniAuth::Stores::Redis.new(OpenStruct.new)}.should raise_error
    end
    
  end

end
