require File.join(File.dirname(__FILE__), 'test_helper')

class TestMD5Tracker < Test::Unit::TestCase

  def setup
    @tmp_dir = File.join(File.dirname(__FILE__), 'tmp')
    FileUtils.mkdir_p(@tmp_dir, :verbose => false) unless File.directory?(@tmp_dir)
    @file1 = File.new(File.join(@tmp_dir, 'file1.txt'), 'w')
    @file2 = File.new(File.join(@tmp_dir, 'file2.txt'), 'w')
  end
  
  def teardown
    FileUtils.rm_rf(@tmp_dir, :verbose => false)
  end
  
  def test_identical_files_match
    @file1.puts("Hello World")
    @file1.close
    file1_md5 = Metricks::MD5Tracker.track(@file1.path, @tmp_dir)
    
    @file2.puts("Hello World")
    @file2.close
    file2_md5 = Metricks::MD5Tracker.track(@file2.path, @tmp_dir)
    
    assert file1_md5 == file2_md5
  end
  
  def test_different_files_dont_match
    @file1.puts("Hello World")
    @file1.close
    file1_md5 = Metricks::MD5Tracker.track(@file1.path, @tmp_dir)

    @file2.puts("Goodbye World")
    @file2.close
    file2_md5 = Metricks::MD5Tracker.track(@file2.path, @tmp_dir)
    
    assert file1_md5 != file2_md5
  end
  
  def test_file_changed
    @file2.close
    
    @file1.puts("Hello World")
    @file1.close
    file1_md5 = Metricks::MD5Tracker.track(@file1.path, @tmp_dir)

    @file1 = File.new(File.join(@tmp_dir, 'file1.txt'), 'w')
    @file1.puts("Goodbye World")
    @file1.close
    assert Metricks::MD5Tracker.file_changed?(@file1.path, @tmp_dir)
  end
  
  def test_file_changed_if_not_tracking
    @file2.close
    
    assert Metricks::MD5Tracker.file_changed?(@file1.path, @tmp_dir)
    assert File.exist?(Metricks::MD5Tracker.md5_file(@file1.path, @tmp_dir))
  end
end
