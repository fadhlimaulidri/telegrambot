module Service
  module Electricity
    class Deploy
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def perform
        begin
          if @message.split(' ').size == 3
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Eg. /deploy staging69.vm master")
          end
        rescue TelegrambotError => e
          bot.api.send_message(chat_id: message.chat.id, text: e.message)
        end
      end
    end
  end
end
