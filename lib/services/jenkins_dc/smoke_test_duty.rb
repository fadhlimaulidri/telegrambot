module Service
  module JenkinsDC
    class SmokeTestDuty
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def perform
        values = JSON.parse(RedisServer.get('smoke_test_duty'))
        username = @message.from.username

        # Get job name from message username
        job = AssigneeSquad['squads'].select { |key, values| values.include?(username) }
        job_name = job.keys.first

        # set job name status to true
        values[job_name]['status'] = true
        RedisServer.set('smoke_test_duty', values.to_json)

        @bot.api.send_message(chat_id: @message.chat.id, text: "#{job_name} sudah diubah menjadi aman")
      rescue => e
        @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
      end
    end
  end
end
