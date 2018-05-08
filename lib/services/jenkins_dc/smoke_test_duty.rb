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
        arr = @message.text.strip.split(' ')
        if arr.size == 2
          values = JSON.parse(RedisServer.get('smoke_test_duty'))

          # check if specified job name is not listed
          if !values.keys.include?(arr[1])
            @bot.api.send_message(chat_id: @message.chat.id, text: "there is no job #{arr[1]}")
            return
          end

          # set job name status to true
          values[arr[1]]['status'] = true
          RedisServer.set('smoke_test_duty', values.to_json)

          @bot.api.send_message(chat_id: @message.chat.id, text: "#{arr[1]} sudah diubah menjadi aman")
        else
          @bot.api.send_message(chat_id: @message.chat.id, text: "Eg. /aman smoke-testing-vp-postpaid")
        end
      rescue => e
        @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
      end
    end
  end
end
