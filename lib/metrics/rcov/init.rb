MetricFu::Configuration.run do |config|
  config.add_metric(:rcov)
  config.add_graph(:rcov)
  config.configure_metric(:rcov,
      { :environment => 'test',
                    :test_files => ['test/**/*_test.rb',
                                    'spec/spec_helper.rb', # NOTE: ensure it is loaded before the specs
                                    'spec/**/*_spec.rb'],
                    :rcov_opts => ["--sort coverage",
                                   "--no-html",
                                   "--text-coverage",
                                   "--no-color",
                                   "--profile",
                                   "--rails",
                                   "--exclude /gems/,/Library/,/usr/,spec"],
                    :external => nil
                  })
end
