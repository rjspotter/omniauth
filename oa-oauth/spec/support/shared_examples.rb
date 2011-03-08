shared_examples_for "an oauth strategy" do

  before do
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
  end

  it 'should be initializable with only two arguments' do
    lambda{ strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}, @store) }.should_not raise_error
  end
  
  it 'should be initializable with a block' do
    lambda{ strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}){|s| s.consumer_store = @store} }.should_not raise_error
  end

  it 'should handle the setting of client options' do
    s = strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}, @store, :client_options => {:abc => 'def'})
    s.consumer_options[:abc].should == 'def'
  end
end

shared_examples_for "an oauth2 strategy" do
  
  before do
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
  end

  it 'should be initializable with only three arguments' do
    lambda{ strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}, @store) }.should_not raise_error
  end
  
  it 'should be initializable with a block' do
    lambda{ strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}){|s| s.consumer_store = @store} }.should_not raise_error
  end

  it 'should handle the setting of client options' do
    s = strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}, @store, :client_options => {:abc => 'def'})
    s.client_options[:abc].should == 'def'
  end
end

shared_examples_for "storage not implemented" do
  it 'should railse NotImplementedError' do
    lambda{ 
      strategy_class.new(lambda{|env| [200, {}, ['Hello World']]}, @store) 
    }.should raise_error(NotImplementedError)
  end
end
