
def compare_paths(path1, path2)
  File.join(MetricFu.root_dir, path1).should == File.join(MetricFu.root_dir, path2)
end


# TODO these directories shouldn't be written in the first place
def cleanup_test_files
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/foo"])
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/is set"])
rescue => e
  mf_debug "Failed cleaning up test files #{e.inspect}"
end


def resources_path
  "#{MetricFu.root_dir}/spec/resources"
end

def setup_fs
  FakeFS::FileSystem.clone('lib')
  FakeFS::FileSystem.clone('.metrics')
  FileUtils.mkdir_p(Pathname.pwd.join(MetricFu.base_directory))
  FileUtils.mkdir_p(Pathname.pwd.join(MetricFu.output_directory))
end
