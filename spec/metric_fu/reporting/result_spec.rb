require "spec_helper"

describe MetricFu do

  describe "#result" do
    it 'should return an instance of Result' do
      MetricFu.result.instance_of?(Result).should be(true)
    end
  end
end

describe MetricFu::Result do

  before(:each) do
    @result = MetricFu::Result.new
  end

  describe "#as_yaml" do
    it 'should call #result_hash' do
      result_hash = mock('result_hash')
      result_hash.should_receive(:to_yaml)

      @result.should_receive(:result_hash).and_return(result_hash)
      @result.as_yaml
    end
  end

  describe "#result_hash" do
  end

  describe "#save_templatized_result" do
    it 'should create a new template class assign a result_hash '\
       'to the template class, and ask it to write itself out' do
      template_class = mock('template_class')
      template_class.should_receive(:new).and_return(template_class)
      MetricFu.should_receive(:template_class).and_return(template_class)
      template_class.should_receive(:result=)
      template_class.should_receive(:per_file_data=)
      template_class.should_receive(:write)
      @result.save_templatized_result
    end
  end

  describe "#add" do
    it 'should add a passed hash to the result_hash instance variable' do
      result_type = mock('result_type')
      result_type.should_receive(:to_s).any_number_of_times.and_return('type')

      result_inst = mock('result_inst')
      result_type.should_receive(:new).and_return(result_inst)

      result_inst.should_receive(:generate_result).and_return({:a => 'b'})
      result_inst.should_receive(:respond_to?).and_return(false)

      MetricFu.should_receive(:send).with(result_type).and_return({})
      MetricFu.should_receive(:const_get).
               with('Type').and_return(result_type)
      result_hash = mock('result_hash')
      result_hash.should_receive(:merge!).with({:a => 'b'})
      @result.should_receive(:result_hash).and_return(result_hash)
      @result.add(result_type)
    end
  end

  describe "#save_output" do
    it 'should write the passed content to dir/index.html' do
      f = mock('file')
      content = 'content'
      @result.should_receive(:open).with('dir/file', 'w').and_yield(f)
      f.should_receive(:puts).with(content)
      @result.save_output(content, 'dir', 'file')
    end
  end

  describe '#open_in_browser? ' do

    before(:each) do
      @config = mock('configuration')
    end

    describe 'when the platform is os x ' do

      before(:each) do
        @config.should_receive(:platform).and_return('darwin')
      end

      describe 'and we are in cruise control ' do

        before(:each) do
          @config.should_receive(:is_cruise_control_rb?).and_return(true)
          MetricFu.stub!(:configuration).and_return(@config)
        end

        it 'should return false' do
          @result.open_in_browser?.should be_false
        end
      end

      describe 'and we are not in cruise control' do

        before(:each) do
          @config.should_receive(:is_cruise_control_rb?).and_return(false)
          MetricFu.stub!(:configuration).and_return(@config)
        end

        it 'should return true' do
          @result.open_in_browser?.should be_true
        end
      end
    end

    describe 'when the platform is not os x ' do
      before(:each) do
        @config.should_receive(:platform).and_return('other')
      end

      describe 'and we are in cruise control' do
        before(:each) do
          MetricFu.stub!(:configuration).and_return(@config)
        end

        it 'should return false' do
          @result.open_in_browser?.should be_false
        end
      end

      describe 'and we are not in cruise control' do
        before(:each) do
          MetricFu.stub!(:configuration).and_return(@config)
        end

        it 'should return false' do
          @result.open_in_browser?.should be_false
        end
      end
    end
  end


  describe '#show_in_browser' do
    it 'should call open with the passed directory' do
      @result.should_receive(:open_in_browser?).and_return(true)
      @result.should_receive(:system).with("open my_dir/index.html")
      @result.show_in_browser('my_dir')
    end

  end
end
