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
        elsif message.text.start_with? "/lock_release"
          ::Service::Staging.lock_release(bot, message)
        elsif message.text.end_with? "/backburner"
          bot.api.send_message(chat_id: message.chat.id, text: "Eg. /backburner:restart/stop/start staging69.vm")
        elsif message.text.start_with? "/backburner:restart"
          ::Service::Staging.backburner(bot, message, "restart")
        elsif message.text.start_with? "/backburner:stop"
          ::Service::Staging.backburner(bot, message, "stop")
        elsif message.text.start_with? "/backburner:start"
          ::Service::Staging.backburner(bot, message, "start")
        elsif message.text.start_with? "/help"
          bot.api.send_message(chat_id: message.chat.id, text: "
            Hai, aku Milea. Salam kenal #{message.from.first_name}
            Kamu bisa pakai command berikut
            /deploy - deploy itu lama biar aku saja
            `Eg. /deploy staging69.vm master` 
            /lock:release
            `Eg. /lock:release staging69.vm` 
            /backburner:start
            `Eg. /backburner:start staging69.vm` 
            /backburner:stop
            `Eg. /backburner:stop staging69.vm`
            /smoketest 
            `E.g : /smoketest run smoke-testing-vp-prepaid` 
          ")
        elsif message.text =~ /^(hai|Hai|hallo|hello|Hallo|Hello)$/
          text = "Hai, aku Milea. Salam kenal #{message.from.first_name}
          ada yang bsa aku bantu?
          /help untuk yg bsa aku bantu"
          bot.api.send_message(chat_id: message.chat.id, text: text)
        elsif message.text =~ /^(iya|Iya)$/
          bot.api.send_message(chat_id: message.chat.id, text: "Koneksi Milea aman")
        elsif message.text.start_with? "/smoketest run"
          ::Service::JenkinsDC.runsmoketest(bot, message)
        elsif message.text.start_with? "smoketest rerun"
          ::Service::JenkinsDC.runsmoketest(bot, message)
        elsif message.text.end_with? "/smoketest"
          bot.api.send_message(chat_id: message.chat.id, text: "Eg. /smoketest run/rerun")
        end
      end
    end
  end
end
