module DNSResolver
  module Logger
    extend self

    def logger
      unless @logger
        @logger = ::Logger.new(STDOUT)
        @logger.level = ::Logger::INFO
      end

      @logger
    end

    def logger=(logger)
      @logger = logger
    end

  end
end
