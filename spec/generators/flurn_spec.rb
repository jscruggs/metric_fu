require File.dirname(__FILE__) + '/../spec_helper'

describe Flurn do  
  it "should compute the flurn for multiple files" do
    f = Flurn.new
    File.should_receive(:open).and_return(easy_yaml)
    flurn_hash = f.analyze
    flurn_hash['app/controllers/primary_sites_controller.rb'].should == 41 + 13.8
    flurn_hash['app/models/link_target.rb'].should == 38 + 29.8
    flurn_hash['app/models/user.rb'].should == 43 + 10.0
  end
end

def easy_yaml
  <<-HERE
:churn: 
  :changes: 
  - :times_changed: 43
    :file_path: app/models/user.rb
  - :times_changed: 41
    :file_path: app/controllers/primary_sites_controller.rb
  - :times_changed: 38
    :file_path: app/models/link_target.rb
:flog: 
  :pages: 
  - :highest_score: 40.5
    :path: /app/controllers/primary_sites_controller.rb
    :score: 247.8
    :average_score: 13.8
  - :highest_score: 70.5
    :path: /app/models/user.rb
    :score: 23.5
    :average_score: 10.0
  - :highest_score: 22.2
    :path: /app/models/link_target.rb
    :score: 300.1
    :average_score: 29.8
  HERE
end