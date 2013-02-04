RSpec::Matchers.define :create_file do |expected|

  match do |block|
    @before = File.exist?(expected)
    block.call
    @after = File.exist?(expected)
    !@before && @after
  end

  failure_message_for_should do |block|
    existed_before_message expected do
      "The file #{expected.inspect} was not created"
    end
  end

  failure_message_for_should_not do |block|
    existed_before_message expected do
      "The file #{expected.inspect} was created"
    end
  end

  def existed_before_message(expected)
    if @before
      "The file #{expected.inspect} existed before, so this test doesn't work"
    else
      yield
    end
  end

end
