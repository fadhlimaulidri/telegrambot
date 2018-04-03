require "telegram/bot"
require "dotenv/load"
require "httparty"
require 'logging'
require './log'

token   = ENV['TOKEN']
domain  = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['HOST']}"
puts domain
headers = {'Content-Type' => 'application/json'}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

  if message.text.end_with? "/deploy"
      bot.api.send_message(chat_id: message.chat.id, text: "Eg. /deploy staging69.vm master")
  elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:restart"
    a = message.text.split(" ")
    url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:restart&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.post(url)
  elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:start"
    a = message.text.split(" ")
    url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:start&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.post(url)
  elsif message.text.split(' ').size == 2 and message.text.start_with? "/backburner:stop"
    a = message.text.split(" ")
    url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=backburner:stop&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.post(url)
  elsif message.text.split(' ').size == 2 and message.text.start_with? "/lock:release"
    a = message.text.split(" ")
    url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=master&staging_action=lock:release&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.post(url)
  elsif message.text.split(' ').size == 3 and message.text.start_with? "/deploy"
    a = message.text.split(" ")
    request_type = 'post'
    url = "http://mileaadnanhussain:dilan@#{ENV['JENKINS_STAGING_HOST']}/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=#{a[2]}&staging_action=deploy&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.send(request_type, url)
  elsif message.text.split(' ').size == 3 and message.text.start_with? "/smoketest run"
    a = message.text.split(" ")
    request_type='post'
    url = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['JENKINS_SMOKETEST_HOST']}/job/#{a[2]}/buildWithParameters?action=false&squad_telegram_id=103443335&automation_branch=master&branch=running_via_milea&user_agent=blcanary"
    HTTParty.send(request_type, url)
  elsif message.text.split(' ').size == 3 and message.text.start_with? "/smoketest rerun"
    a = message.text.split(" ")
    request_type='post'
    url = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['JENKINS_SMOKETEST_HOST']}/job/#{a[2]}/buildWithParameters?action=true&squad_telegram_id=103443335&automation_branch=master&branch=running_via_milea&user_agent=blcanary"
    HTTParty.send(request_type, url)
  else
    case message.text
    when 'hai','Hai','hallo','hello','Hallo','Hello'
      bot.api.send_message(chat_id: message.chat.id, text: "Hai, aku Milea. Salam kenal #{message.from.first_name}")	
      bot.api.send_message(chat_id: message.chat.id, text: "ada yang bsa aku bantu?")	
      bot.api.send_message(chat_id: message.chat.id, text: "/run smoketest")	
      bot.api.send_message(chat_id: message.chat.id, text: "/rerun run only flaky scenario smoketest")	
    when '/help'
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
      
    when '/run'
      request_type = 'post'
      url          = "#{domain}/job/vp-prepaid/buildWithParameters?action=false"
      # body         = {:parameter =>[{:name=>"action", :value => "run"}]}
      options      = { headers: headers}	
      
      HTTParty.send(request_type, url, options)
    
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, udah aku run ya #{message.from.first_name}")
    when '/rerun'
      request_type = 'post'
      url          = "#{domain}/job/vp-prepaid/buildWithParameters?action=true"      

      options = { headers: headers}	
      HTTParty.send(request_type, url, options)
      bot.api.send_message(chat_id: message.chat.id, text: "Udah aku rerun scenario yang gagal ya #{message.from.first_name}")
    when 'iya','Iya'
      # staging_validate('staging30.vm')
      bot.api.send_message(chat_id: message.chat.id, text: "iya bacot")
    when 'rerun smoketest'
      url          = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['JENKINS_SMOKETEST_HOST']}/job/smoke-testing-vp-prepaid/buildWithParameters"
      
      body = {
      	:parameter => [
      		{:name => "action", :value =>"rerun"},
      		{:name => "squad_telegram_id", :value => "103443335"},
      		{:name => "automation_branch", :value => "master"},
      		{:name => "branch", :value => "curl"},
      		{:name => "user_agent", :value => "blcanary"}
      		]
      	}

      options      = { headers: headers, body: body}	
      request_type='post'

      HTTParty.send(request_type, url, options)

      bot.api.send_message(chat_id: message.chat.id, text: "Udah aku rerun smoketest scenario yang gagal vp-prepaid ya #{message.from.first_name}")
      	  
    end

  end
  #end if
  logchat(message.chat.id, message.from.first_name, message.from.last_name, message.from.username, message.text)

  end
end

# Try catch
  begin
    
  rescue Telegram::Bot::Exceptions::ResponseError
    bot.api.send_message(chat_id: 103443335, text: "Milea kena Telegram::Bot::Exceptions::ResponseError, cek service plis")
  rescue Faraday::ConnectionFailed
    bot.api.send_message(chat_id: 103443335, text: "Milea kena Faraday::ConnectionFailed, cek service plis")   
  else
    bot.api.send_message(chat_id: 103443335, text: "Milea")   
  end
# End try catch 