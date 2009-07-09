require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Grapher do
  it "should blow up if gruff is not availible" do
    Grapher.should_receive(:require).and_raise(LoadError)
    Grapher.should_receive(:puts).with(/config\.graphs/)
    lambda {Grapher.new}.should raise_error(LoadError) 
  end
end