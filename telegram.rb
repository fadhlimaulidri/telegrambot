require "telegram/bot"
require "dotenv/load"
require "httparty"

token   = ENV['TOKEN']
domain  = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@#{ENV['HOST']}"
puts domain
headers = {'Content-Type' => 'application/json'}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

  if message.text.end_with? "/deploy"
      bot.api.send_message(chat_id: message.chat.id, text: "Eg. /deploy staging_server staging_branch")
  elsif message.text.split(' ').size == 3 and message.text.start_with? "/deploy"
    a = message.text.split(" ")
    request_type = 'post'
    url = "http://mileaadnanhussain:dilan@qa-jenkins.vm:8080/job/Staging%20Deployment/buildWithParameters?staging_server=#{a[1]}&staging_user=bukalapak&staging_branch=#{a[2]}&staging_action=deploy&migrate=true&reindex=false&normalize_date=true&telegram_id=#{message.chat.id}"
    HTTParty.send(request_type, url)
    bot.api.send_message(chat_id: message.chat.id, text: "Udah aku deploy ya #{message.from.first_name}")
  else  
    
    case message.text
    when 'hai','Hai','hallo','hello','Hallo','Hello'
      bot.api.send_message(chat_id: message.chat.id, text: "Hai, aku Milea. Salam kenal #{message.from.first_name}")	
      bot.api.send_message(chat_id: message.chat.id, text: "ada yang bsa aku bantu?")	
      bot.api.send_message(chat_id: message.chat.id, text: "/run smoketest")	
      bot.api.send_message(chat_id: message.chat.id, text: "/rerun run only flaky scenario smoketest")	
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
      bot.api.send_message(chat_id: message.chat.id, text: "iya bacot")	
    when 'run smoketest'
      url          = "http://mileaadnanhussain:dilan@172.16.8.89:8080/job/smoke-testing-vp-prepaid/buildWithParameters"

      body = {
      	:parameter => [
      		{:name => "action", :value =>"run"},
      		{:name => "squad_telegram_id", :value => "103443335"},
      		{:name => "automation_branch", :value => "master"},
      		{:name => "branch", :value => "curl"},
      		{:name => "user_agent", :value => "blcanary"}
      		]
      	}

      options      = { headers: headers, body: body}
      request_type='post'

      HTTParty.send(request_type, url, options)
      	
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, udah aku run smoketest-vp-prepaid ya #{message.from.first_name}")
    when 'rerun smoketest'
      url          = "http://mileaadnanhussain:dilan@172.16.8.89:8080/job/smoke-testing-vp-prepaid/buildWithParameters"
      
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
  end
end
