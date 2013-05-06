module MfDebugger
  extend self

  class Logger
    class << self
      attr_accessor :debug_on
      @debug_on = false
    end
    def self.log(msg, &block)
      if block_given?
        block.call
      end
      STDOUT.puts '*'*5 + msg.to_s
    end
    def self.debug(msg, &block)
      if MfDebugger::Logger.debug_on
        if block_given?
          log(msg,&block)
        else
          log(msg)
        end
      end
    end
  end

  def mf_debug(msg,&block)
    MfDebugger::Logger.debug(msg, &block)
  end

  def mf_log(msg,&block)
    MfDebugger::Logger.log(msg, &block)
  end

end
