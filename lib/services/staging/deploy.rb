module Service
  module Staging
    class Deploy
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
        @conn = ::Connection.new(
          'http',
          ENV['JENKINS_STAGING_HOST'],
          "Basic #{JenkinsConfiguration['staging']['authorization']}"
        )
      end

      def perform
        begin
          arr = @message.text.strip.split(' ')
          if arr.size == 3
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
            @conn.post('job/Staging%20Deployment/buildWithParameters', param)
          else
            @bot.api.send_message(chat_id: @message.chat.id, text: "Eg. /deploy staging69.vm master")
          end
        rescue TelegrambotError => e
          LoggerOut.error("#{@message.chat.id}, #{@message.from.first_name}, #{@message.from.last_name}, #{@message.from.username}, #{e.message}")
          @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
        end
      end
    end
  end
end
