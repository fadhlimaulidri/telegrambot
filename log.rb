def logchat(chatid, firstname, lastname, username, message )
  logger = Logging.logger['chat_log']
  logger.level = :info

  logger.add_appenders \
  Logging.appenders.stdout,
  Logging.appenders.file('request.log')

  # logger.debug "this debug message will not be output by the logger"
  logger.info "#{chatid} #{firstname} #{lastname} @#{username} #{message}"
end