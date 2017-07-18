# Welcome to our Sample Chatbot App, powered by Chatbot
require 'httparty'

@header = {
  "Accept": "application/json",
  "X-Api-Key": "wBA7N4NiYpw3O4IK709Wo8QpUCa1uvm8AJnayEm2" #YOUR OWN XAPIX Authentication (token_auth)
}

@bitcoin_url = "https://xap.ix-io.net/api/v1/coin_market_cap/specific_currencies?filter%5Bcurrency%5D=bitcoin&fields%5Bspecific_currencies%5D=currency%2Cname%2Csymbol%2Crank%2Cprice_usd%2Cprice_btc%2Cvolume_usd_24h%2Cmarket_cap_usd%2Cavailable_supply%2Ctotal_supply%2Cpercent_change_1h%2Cpercent_change_24h%2Cpercent_change_7d%2Clast_updated%2Cx_id&sort=currency&page%5Bnumber%5D=1&page%5Bsize%5D=10000
"
@bitcoin_info = HTTParty.get(@bitcoin_url, headers: @header) 
@bitcoin_current_price = @bitcoin_info["specific_currencies"][0]["price_usd"] 
@bitcoin_percent_change_1h = @bitcoin_info["specific_currencies"][0]["percent_change_1h"].to_f

def bitcoin_price_alert
  	if @bitcoin_percent_change_1h > 1
  		send_slack_message("Bitcoin has jumped #{@bitcoin_percent_change_1h} percent in the past hour! The current price is #{@bitcoin_current_price} USD.")
  	elsif @bitcoin_percent_change_1h < -1
  		bitcoin_percent_change_1h_positive = -@bitcoin_percent_change_1h
  		send_slack_message("Bitcoin has dropped #{@bitcoin_percent_change_1h_positive} percent in the past hour! The current price is #{@bitcoin_current_price} USD.")
  	end 
end 

def send_slack_message(message)
	webhook_url="https://hooks.slack.com/services/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"
	body={
	    "text":message
	}.to_json
	header_slack={"Content-type": "application/json"}
	HTTParty.post(webhook_url, body: body, headers: @header) 
end 

puts "Bitcoin has jumped #{@bitcoin_percent_change_1h} percent in the past hour! The current price is #{@bitcoin_current_price} USD."
bitcoin_price_alert









