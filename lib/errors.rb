class TelegrambotError < StandardError
  attr_accessor :code, :message
  def initialize(msg, code = 33_000)
    @code = code
    @message = msg
    super(msg)
  end
end

module AlphaBrokerBot
  class ConnectionError < TelegrambotError
    def initialize(msg = "connection to api is error")
      super(msg, 33_001)
    end
  end
end
