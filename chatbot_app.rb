# Welcome to our Sample Chatbot App, powered by Chatbot
require 'HTTParty'

@phone_number = "+16175832486" #YOUR OWN PHONE NUMBER(Must be verified on twilio)
@chatbot_number = "+16176525519" #YOUR TWILIO NUMBER(Find it here - https://www.twilio.com/console/phone-numbers/incoming)

@header = {
  "Accept": "application/json",
  "X-Api-Key": "O7heYA7UMPksj98IrTDeRRJ0jWyIS9ODaD492wBk" #YOUR OWN XAPIX Authentication (token_auth)
}

@received_message_url = "https://xap.ix-io.net/api/v1/twilio/account_messages?filter%5Baccount_sid%5D=AC0d8bb04ed7587bb49fdccc8ca5cff8fc&fields%5Baccount_messages%5D=first_page_uri&include=messages&sort=account_sid&page%5Bnumber%5D=1&page%5Bsize%5D=100
"


def send_message(message)

	send_message_url = "https://xap.ix-io.net/api/v1/twilio/message_creations"

	body={
	  "data": {
	    "account_sid": "AC0d8bb04ed7587bb49fdccc8ca5cff8fc", #YOUR OWN TWILIO ACCOUNT_SID
	    "body": message,
	    "from_number": @chatbot_number,
	    "to_number": @phone_number
	  }
	}.to_json

	send_message = HTTParty.post(send_message_url, body: body, headers: @header) 
end 

def wait_for_message
	sleep(1) until HTTParty.get(@received_message_url, headers: @header)['messages'][0]["from"]==@phone_number
end 

def latest_message
	HTTParty.get(@received_message_url, headers: @header)['messages'][0]["body"]
end 

def wikipedia
	send_message("Hi! I'm your Wikipedia chatbot! What do you want to know more about?")
	loop do 
		wait_for_message
		title=latest_message.split.map(&:capitalize).join('_')
	wikipedia_url = "https://xap.ix-io.net/api/v1/wikipedia/page_summary?filter%5Btitle%5D=#{title}&fields%5Bpage_summary%5D=title%2Cextract%2Clang%2Cdir%2Ctimestamp%2Cdescription%2Crandom_id%2Cthumbnail_height%2Cthumbnail_width%2Cthumbnail_source&sort=random_id&page%5Bnumber%5D=1&page%5Bsize%5D=100"
	wikipedia_response = HTTParty.get(wikipedia_url, headers: @header) 
	wikipedia_extract = wikipedia_response["page_summary"].first["extract"]
	puts "You searched for '#{latest_message}'. And Here's the information on wikipedia about '#{latest_message}'. This information is also sent to your number #{@phone_number}."
	puts "----"
	puts wikipedia_extract
	send_message(wikipedia_extract)
	puts "----"
	puts "Send another word you want to know more about to the chatbot or Press Control+C to exit."
	puts "----"
	end 
end 


puts "chatbot running..."
puts "Press Control+C to exit"
wikipedia











