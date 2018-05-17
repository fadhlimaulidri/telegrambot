module Service
  module JenkinsDC
    class RunSmoketest
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
        @conn = ::Connection.new(
          'http',
          ENV['JENKINS_DC_HOST'],
          "Basic #{JenkinsConfiguration['data_center']['authorization']}"
        )
      end

      def perform
        begin
          arr = @message.text.strip.split(' ')
          if arr.size == 2
            param = {
              action: 'false',
              squad_telegram_id: @message.chat.id,
              automation_branch: 'master',
              branch: 'running_via_milea',
              user_agent: 'blcanary'             
            }
            @conn.post('job/smoke-testing-dgt/buildWithParameters', param)
          else
            @bot.api.send_message(chat_id: @message.chat.id, text: "Eg. /run smoketest master")
          end
        rescue TelegrambotError => e
          LoggerOut.error("#{@message.chat.id}, #{@message.from.first_name}, #{@message.from.last_name}, #{@message.from.username}, #{e.message}")
          @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
        end
      end
    end
  end
end
