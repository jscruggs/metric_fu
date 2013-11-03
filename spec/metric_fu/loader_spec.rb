require 'spec_helper'

describe MetricFu do

  it "loads the .metrics file" do
    # Global only for testing that this file gets loaded
    $metric_file_loaded = false
    MetricFu.loader.load_user_configuration
    $metric_file_loaded.should be_true
  end

end
