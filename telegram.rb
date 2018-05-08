require_all './config/*.rb'
require_all './lib/**/*.rb'

class TelegramBotApp
  puts 'background is started'
  ::Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|
    bot.listen do |message|
      if message.text.nil?
      else
        LoggerOut.info("#{message.chat.id}, #{message.from.first_name}, #{message.from.last_name}, #{message.from.username}, #{message.text}")
        if message.text.start_with? "/deploy"
          ::Service::Staging.deploy(bot, message)
        elsif message.text.start_with? "/aman"
          ::Service::JenkinsDC.smoke_test_duty(bot, message)
        elsif message.text.start_with? "/failed_smoketest"
          ::Service::JenkinsDC.failed_smoke_test(bot, message)
        end
      end
    end
  end
end
