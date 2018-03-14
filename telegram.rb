require "telegram/bot"
require "dotenv/load"
require "httparty"

token=ENV['TOKEN']

domain='http://mileaadnanhussain:dilan@my-jenkins.vm:8080/job/vp-prepaid/build'

headers = {'Content-Type' => 'application/json'}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when 'hai','Hai'
      bot.api.send_message(chat_id: message.chat.id, text: "Hai, aku Milea. Salam kenal #{message.from.first_name} Sayang")	
      bot.api.send_message(chat_id: message.chat.id, text: "ada yang bsa aku bantu?")	
      bot.api.send_message(chat_id: message.chat.id, text: "/run smoketest")	
      bot.api.send_message(chat_id: message.chat.id, text: "/rerun run only flaky scenario smoketest")	
    when '/run'
      request_type='post'
      
      body = {:parameter =>[{:name=>"action", :value => "run"}]}

      options = { headers: headers, body: body}	
      HTTParty.send(request_type, domain, options)
    
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, udah aku run ya #{message.from.first_name} Sayang")
    when '/rerun'
      request_type='post'
      
      body = {:parameter =>[{:name=>"action", :value => "rerun"}]}

      options = { headers: headers, body: body}	
      HTTParty.send(request_type, domain, options)
      bot.api.send_message(chat_id: message.chat.id, text: "Udah aku rerun scenario yang gagal ya #{message.from.first_name} Sayang")
    when 'iya','Iya'
      bot.api.send_message(chat_id: message.chat.id, text: "iya bacot")
    when 'deploy'
      qa_jenkins = 'http://mileaadnanhussain:dilan@qa-jenkins.vm:8080/job/vp-prepaid-automation/buildWithParameters?deploy_branch=true&staging_branch=v4-refactor-token-listrik&migrasi-electricity-prepaid'  

      request_type='post'
      
      body = {:parameter =>[{:name => "deploy_branch", :value => true},{:name => "staging_branch", :value => "v4-refactor-token-listrik"},{:name => "automation_branch", :value => "migrasi-electricity-prepaid"}]}

      options = { headers: headers, body: body}	
      puts HTTParty.send(request_type, qa_jenkins, options)
      bot.api.send_message(chat_id: message.chat.id, text: "Udah aku deploy ya #{message.from.first_name} Sayang")
    end
  end
end
