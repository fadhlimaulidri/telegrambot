def logchat(chatid, firstname, lastname, username, message )
  logger = Logging.logger['chat_log']
  logger.level = :info
  logger.add_appenders \
  Logging.appenders.stdout,
  Logging.appenders.file('request.log')
  logger.info "#{chatid} #{firstname} #{lastname} @#{username} #{message}"
end

def post(url)
  response = HTTParty.post(url)
  puts "body: #{response.body}" 
  puts "code: #{response.code}"
  puts "message: #{response.message}"
  puts "header: #{response.headers.inspect}"
end