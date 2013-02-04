MetricFu::Configuration.run do |config|
  config.add_metric(:rcov)
  config.add_graph(:rcov)
    rcov_opts = [
      "--sort coverage",
      "--no-html",
      "--text-coverage",
      "--no-color",
      "--profile",
      "--exclude-only '.*'",
      '--include-file "\Aapp,\Alib"'
    ]
    rcov_opts << "-Ispec" if File.exist?("spec")
  config.configure_metric(:rcov,
      { :environment => 'test',
                    :test_files =>  Dir['{spec,test}/**/*_{spec,test}.rb'],
                    :rcov_opts => rcov_opts,
                    :external => nil
                  })
end
