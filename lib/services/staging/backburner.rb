module Service
  module Staging
    class Backburner
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message, actions)
      	@actions = actions
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
          backburner_action = "backburner:" + @actions
          puts "backburner action: #{backburner_action}"
          arr = @message.text.strip.split(' ')
          if arr.size == 2
            param = {
              staging_server: arr[1],
              staging_user: 'bukalapak',
              staging_branch: 'master',
              staging_action: backburner_action,
              migrate: true,
              reindex: false,
              normalize_date: true,
              telegram_id: @message.chat.id
            }
            @conn.post('job/Staging%20Deployment/buildWithParameters', param)
          else
            @bot.api.send_message(chat_id: @message.chat.id, text: "Eg. /backburner:restart/stop/start staging34.vm")
          end
        rescue TelegrambotError => e
          LoggerOut.error("#{@message.chat.id}, #{@message.from.first_name}, #{@message.from.last_name}, #{@message.from.username}, #{e.message}")
          @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
        end
      end
    end
  end
end
