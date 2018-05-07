require './helper'
require_all './config/*.rb'
require_all './lib/**/*.rb'

class TelegramBotApp
  puts ENV['TOKEN']
  ::Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|
    bot.listen do |message|
      if message.text.nil?
      elsif message.text.start_with? "/deploy"
        ::Service::Staging.deploy(bot, message)
      end
    end
  end
end
