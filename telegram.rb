require "telegram/bot"
require "dotenv/load"
require "httparty"
require 'logging'
require './helper'
require 'net/ssh'

token   = ENV['TOKEN']
domain  = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['HOST']}"
puts domain
headers = {'Content-Type' => 'application/json'}

Telegram::Bot::Client.run(token) do |bot|
  begin # Try catch
    bot.listen do |message|
      puts message.text
      if message.text.nil?
      elsif message.text.end_with? "/deploy"
          bot.api.send_message(chat_id: message.chat.id, text: "Eg. /deploy staging69.vm master")
      elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:restart"
        a = message.text.split(" ")
        url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:restart&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
        post(url)
      elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:start"
        a = message.text.split(" ")
        url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:start&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
        HTTParty.post(url)
      elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:stop"
        a = message.text.split(" ")
        url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:stop&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
        post(url)
      elsif message.text.split(' ').size == 2 and message.text.start_with? "/lock:release"
        a = message.text.split(" ")
        url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=lock:release&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
        post(url)
      elsif message.text.split(' ').size == 3 and message.text.start_with? "/deploy"
        a = message.text.split(" ")
        url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=#{a[2]}&staging_action=deploy&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
        post(url)
      elsif message.text.split(' ').size == 3 and message.text.start_with? "/smoketest run"
        a = message.text.split(" ")
        request_type='post'
        url = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['JENKINS_SMOKETEST_HOST']}/job/#{a[2]}/buildWithParameters?action=false&squad_telegram_id=103443335&automation_branch=master&branch=running_via_milea&user_agent=blcanary"
        post(url)
      elsif message.text.split(' ').size == 3 and message.text.start_with? "/smoketest rerun"
        a = message.text.split(" ")
        url = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['JENKINS_SMOKETEST_HOST']}/job/#{a[2]}/buildWithParameters?action=true&squad_telegram_id=103443335&automation_branch=master&branch=running_via_milea&user_agent=blcanary"
        post(url)
      elsif message.text =~ /^(hai|Hai|hallo|hello|Hallo|Hello)$/
          text = "Hai, aku Milea. Salam kenal #{message.from.first_name}
          ada yang bsa aku bantu?
          /help untuk yg bsa aku bantu"
          bot.api.send_message(chat_id: message.chat.id, text: text)
      elsif message.text.split('-').size == 3 and message.text.start_with? "ssh"
        a = message.text.split("-")
        @hostname = a[1]
        @username = "bukalapak"
        @password = "bukalapak"
        @cmd = a[2]
        begin
          ssh = Net::SSH.start(@hostname, @username, :password => @password)
          response = ssh.exec!(@cmd)
          ssh.close
          bot.api.send_message(chat_id: message.chat.id, text: response)
        rescue
          "Unable to connect to #{@hostname} using #{@username}/#{@password}"
        end
      elsif message.text == '/help'
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
          ")
      elsif message.text =~ /^(iya|Iya)$/
          # staging_validate('staging30.vm')
          bot.api.send_message(chat_id: message.chat.id, text: "iya")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "kakak ngomong apa sih? aku gak ngerti")
      end
      #end if
    logchat(message.chat.id, message.from.first_name, message.from.last_name, message.from.username, message.text)
    end
  rescue Telegram::Bot::Exceptions::ResponseError
    bot.api.send_message(chat_id: 103443335, text: "Milea kena Telegram::Bot::Exceptions::ResponseError, cek service plis")
  rescue Faraday::ConnectionFailed
    bot.api.send_message(chat_id: 103443335, text: "Milea kena Faraday::ConnectionFailed, cek service plis")   
  else
    bot.api.send_message(chat_id: 103443335, text: "Milea")   
  end
  # End try catch
end

 