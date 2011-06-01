require 'spec_helper'

describe 'As the base class Omniauth::Stores::Base' do

  context "after being created" do

    before do
      @store = OmniAuth::Stores::Base.new
    end

    context "connection to store" do
      
      it "should have a connection getter" do
        @store.should respond_to(:connection)
      end

      it "should have a connection setter" do
        @store.should respond_to(:connection=)
      end

    end

    context "so that the developer can access the correct key" do
      
      it "should stub" do
        expect {@store.key("identifier")}.to raise_error(NotImplementedError)
      end

      it "should expect at least one parameter" do
        expect {@store.key}.to raise_error(ArgumentError)
      end

      it "should work with two arguements" do
        expect {@store.key("identifier", "strategy")}.to raise_error(NotImplementedError) 
      end

      it "should accept a maximum of 2 arguments" do
        expect {@store.key("1", "2", "3")}.to raise_error(ArgumentError)
      end

    end

    context "so that the developer can access the correct secret" do
      
      it "should stub" do
        expect {@store.secret("identifier")}.to raise_error(NotImplementedError)
      end

      it "should expect at least one parameter" do
        expect {@store.secret}.to raise_error(ArgumentError)
      end

      it "should work with two arguements" do
        expect {@store.secret("identifier", "strategy")}.to raise_error(NotImplementedError) 
      end

      it "should accept a maximum of 2 arguments" do
        expect {@store.secret("1", "2", "3")}.to raise_error(ArgumentError)
      end

    end

    context "so that the developer can have a custom callback" do
      
      it "should stub" do
        expect {@store.callback('identifier')}.to raise_error(NotImplementedError)
      end

    end

    context "so that the developer can access the correct strategy" do
      
      it "should stub" do
        expect {@store.strategy}.to raise_error(NotImplementedError)
      end

      it "should expect no parameter" do
        expect {@store.strategy("something")}.to raise_error(ArgumentError)
      end

    end
    
  end

end
