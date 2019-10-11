class EventsLogger
  def call(event)
    logger.info("\n#{'- '*80}\n#{event.class.to_s} published. Data: #{event.data.inspect}\n#{'- '*80}\n")
  end

  private

  attr_reader :logger

  def initialize(logger)
    @logger = logger
  end
end
