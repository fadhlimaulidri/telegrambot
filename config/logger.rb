require 'logstash-logger'

# refactored logger
LoggerOut = LogStashLogger.new(
  type: :stdout,
  format: :json_lines
)
