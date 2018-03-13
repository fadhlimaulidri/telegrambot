require "telegram/bot"
require "dotenv"
require "httparty"

# token=ENV['TOKEN']
token='558463303:AAHQf5ZQfx1OUbtbz3uQXADMi7Cp8-2V3DQ'

domain='http://fadhlimaulidri:password@my-jenkins.vm:8080/job/vp-prepaid/build'
headers = {'Content-Type' => 'application/json'}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/run'
      request_type='post'
      
      body = {:parameter =>[{:name=>"action", :value => "run"}]}

      options = { headers: headers, body: body}	
      HTTParty.send(request_type, domain, options)
    
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/rerun'
      request_type='post'
      
      body = {:parameter =>[{:name=>"action", :value => "rerun"}]}

      options = { headers: headers, body: body}	
      HTTParty.send(request_type, domain, options)
    end
  end
end
