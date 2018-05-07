module Service
  module Staging
    class Deploy < Base
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def perform
        begin
          arr = @message.split(' ')
          if arr.size == 3
            conn = ::Connection.new('http', ENV['JENKINS_STAGING_HOST'])
            param = {
              staging_server: arr[1],
              staging_user: 'bukalapak',
              staging_branch: arr[2],
              staging_action: 'deploy',
              migrate: true,
              reindex: false,
              normalize_date: true,
              telegram_id: @message.chat.id
            }
            conn.post('job/Staging%20Deployment/buildWithParameters', param)
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Eg. /deploy staging69.vm master")
          end
        rescue TelegrambotError => e
          LoggerOut.info(e)
          bot.api.send_message(chat_id: message.chat.id, text: e.message)
        end
      end
    end
  end
end
