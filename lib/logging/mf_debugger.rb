module MfDebugger
  class Logger
    class << self
      attr_accessor :debug_on
      @debug_on = false
    end
  end

  def self.mf_debug(msg,&block)
    if MfDebugger::Logger.debug_on
      if block_given?
        block.call
      end
      STDOUT.puts msg
    end
  end
  def mf_debug(msg,&block)
    if block_given?
      MfDebugger.mf_debug(msg,&block)
    else
      MfDebugger.mf_debug(msg)
    end
  end
end
