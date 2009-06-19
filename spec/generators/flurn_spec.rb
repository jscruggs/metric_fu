require File.dirname(__FILE__) + '/../spec_helper'

describe Flurn do
  it "should description" do
     f = Flurn.new
     # YAML::load(File.open('report.yml'))
     File.should_receive(:open).and_return(easy_yaml)
     flurn_hash = f.analyze
     flurn_hash['primary_sites_controller'].should == 41 + 13.8
  end
end

def easy_yaml
  <<-HERE
:churn: 
  :changes: 
  - :times_changed: 43
    :file_path: app/views/primary_sites/show.html.haml
  - :times_changed: 41
    :file_path: app/controllers/primary_sites_controller.rb
  - :times_changed: 38
    :file_path: app/models/link_target.rb
  - :times_changed: 30
:flog: 
  :pages: 
  - :highest_score: 40.5
    :path: /app/controllers/primary_sites_controller.rb
    :score: 247.8
    :average_score: 13.8
  HERE
end