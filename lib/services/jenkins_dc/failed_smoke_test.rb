module Service
  module JenkinsDC
    class FailedSmokeTest
      # var bot is telegram bot object
      # var message is telegram message object
      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def perform
        values = JSON.parse(RedisServer.get('smoke_test_duty'))
        failed_jobs = values.select { |name, jobs| !jobs['status'] }

        fail_job_reports = []
        if failed_jobs.empty?
          @bot.api.send_message(chat_id: @message.chat.id, text: 'Smoketest nya sudah berhasil semua!')
        else
          failed_jobs.each do |name, jobs|
            if jobs['usernames'] 
              usernames = jobs['usernames'].map { |username| "@#{username}" }
              fail_job_reports << "#{name} #{usernames.join(', ')}"
            end
          end
        end

        @bot.api.send_message(chat_id: @message.chat.id, text: message_result(fail_job_reports))
      rescue => e
        @bot.api.send_message(chat_id: @message.chat.id, text: e.message)
      end

      private

      def message_result(fail_jobs)
        result = "Dibawah ini smoke test yang merah:\n"
        fail_jobs.each do |name|
          result << "#{name}\n"
        end

        result
      end
    end
  end
end
