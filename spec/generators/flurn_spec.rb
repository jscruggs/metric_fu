require File.dirname(__FILE__) + '/../spec_helper'

describe Flurn do  
  it "should compute the flurn for multiple files" do
    MetricFu::Configuration.run {}
    File.stub!(:directory?).and_return(true)

    f = MetricFu::Flurn.new
    MetricFu.should_receive(:report).and_return(mock('Report', :report_hash => churn_and_flog_hash))
    flurn_hash = f.analyze
    flurn_hash['app/controllers/primary_sites_controller.rb'].should == 41 + 13.8
    flurn_hash['app/models/link_target.rb'].should == 38 + 29.8
    flurn_hash['app/models/user.rb'].should == 43 + 10.0
  end
end

def churn_and_flog_hash
  {:churn => {
    :changes => [
                  {
                    :file_path => "app/models/user.rb",
                    :times_changed => 43},
                  {
                    :file_path => "app/controllers/primary_sites_controller.rb",
                    :times_changed => 41
                  },
                  {
                    :file_path => "app/models/link_target.rb",
                    :times_changed => 38
                  }
                ]
            },
    :flog => {
              :pages => [
                          {
                            :path => "/app/controllers/primary_sites_controller.rb",
                            :highest_score => 40.5,
                            :score => 247.8,
                            :average_score => 13.8
                          },
                          {
                            :path=>"/app/models/user.rb",
                            :highest_score => 70.5,
                            :score=>23.5,
                            :average_score=>10.0
                          },
                          {
                            :path=>"/app/models/link_target.rb",
                            :highest_score=>22.2,
                            :score=>300.1,
                            :average_score=>29.8
                          }
                        ]
            }
  }
  
end
