require 'spec_helper'
require 'ostruct'

describe 'OmniAuth::Stores::Redis' do

  before do
    ::Redis  = double()
    @redis = double()
    @redis.stub(:class).and_return ::Redis
  end

  context "when configuring and creating" do

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

    it "should make the connection available via connection method" do
      OmniAuth::Stores::Redis.new(@redis).connection.should == @redis
    end

    it "should take a strategy as a second argument" do
      expect {OmniAuth::Stores::Redis.new(@redis, "coolprovider")}.should_not raise_error
    end

    it "should make strategy available as strategy if set" do
      OmniAuth::Stores::Redis.new(@redis, "coolprovider").strategy.should == "coolprovider"
    end
    
  end

  context "when accessing credentials" do

    before do
      @redis.stub(:lindex).with("developerid:explicitstrategy",0).and_return("theapikey")
      @redis.stub(:lindex).with("developerid:implicitstrategy",0).and_return("otherapikey")
      @redis.stub(:lindex).with("developerid:explicitstrategy",1).and_return("thesecret")
      @redis.stub(:lindex).with("developerid:implicitstrategy",1).and_return("othersecret")
      @redis.stub(:get).with("developerid:mask").and_return("http://example.com/sitepass/")
      @store = OmniAuth::Stores::Redis.new(@redis, "implicitstrategy")
    end
    
    it "should not raise error when calling key" do
      expect {@store.key("developerid")}.should_not raise_error
    end

    context "and using an explicit stragety" do

      it "should not raise when key is called with two args" do
        expect {@store.key("developerid", "explicitstrategy")}.should_not raise_error
      end

      it "should return the api key for the explicit strategy" do
        @store.key("developerid", "explicitstrategy").should == "theapikey"
      end


      it "should not raise when secret is called with two args" do
        expect {@store.secret("developerid", "explicitstrategy")}.should_not raise_error
      end

      it "should return the api secret for the explicit strategy" do
        @store.secret("developerid", "explicitstrategy").should == "thesecret"
      end

    end

    context "and using an implicit stragety" do
      
      it "should return the api key for the implicit strategy" do
        @store.key("developerid").should == "otherapikey"
      end

      it "should return the api secret for the implicit strategy" do
        @store.secret("developerid").should == "othersecret"
      end

    end

    context "for all strategies both explicit and implicit" do
      
      it "should return the callback" do
        @store.callback("developerid").should == 'http://example.com/sitepass/'
      end

    end

  end

end
