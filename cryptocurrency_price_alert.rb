# Welcome to our Cryptocurrency Price Alert App, powered by XapiX
require 'httparty'

@header = {
  "Accept": "application/json",
  "X-Api-Key": "YOUR OWN XAPIX Authentication (token_auth)", 
  "X-Device-User-Token": "YOUR Device-User-Token (can be copied from requested headers session in any query)"
  }

@channel="YOUR SLACK USERNAME IN THE FORMAT OF @username"

@bitcoin_url = "https://xap.ix-io.net/api/v1/coin_market_cap/specific_currencies?filter%5Bcurrency%5D=bitcoin&fields%5Bspecific_currencies%5D=currency%2Cname%2Csymbol%2Crank%2Cprice_usd%2Cprice_btc%2Cvolume_usd_24h%2Cmarket_cap_usd%2Cavailable_supply%2Ctotal_supply%2Cpercent_change_1h%2Cpercent_change_24h%2Cpercent_change_7d%2Clast_updated%2Cx_id&sort=currency&page%5Bnumber%5D=1&page%5Bsize%5D=10000
"
@bitcoin_info = HTTParty.get(@bitcoin_url, headers: @header) 
@bitcoin_current_price = @bitcoin_info["specific_currencies"][0]["price_usd"] 
@bitcoin_percent_change_1h = @bitcoin_info["specific_currencies"][0]["percent_change_1h"].to_f

def bitcoin_price_alert
  	if @bitcoin_percent_change_1h > 1
  		send_slack_message("Bitcoin has jumped #{@bitcoin_percent_change_1h} percent in the past hour! The current price is #{@bitcoin_current_price} USD.")
  	elsif @bitcoin_percent_change_1h < -1
  		@bitcoin_percent_change_1h_positive = - @bitcoin_percent_change_1h
  		send_slack_message("Bitcoin has dropped #{@bitcoin_percent_change_1h_positive} percent in the past hour! The current price is #{@bitcoin_current_price} USD.")
  	end 
end 

def send_slack_message(message)
    channel_url=CGI.escape(@channel)
    message_url=CGI.escape(message)
    send_message_url="https://xap.ix-io.net/api/v1/slack_api/chat_postMessages?filter%5Bchannel%5D=#{channel_url}&filter%5Btext%5D=#{message_url}&fields%5Bchat_postMessages%5D=x_ok%2Cchannel%2Cx_ts%2Cmessage_text%2Cmessage_username%2Cmessage_bot_id%2Cmessage_type%2Cmessage_subtype%2Ctext%2Cmessage_x_ts&sort=x_ts&page%5Bnumber%5D=1&page%5Bsize%5D=100"
    
    send_message = HTTParty.get(send_message_url, headers: @header) 
end 

puts "Bitcoin has changed #{@bitcoin_percent_change_1h} percent in the past hour! The current price is #{@bitcoin_current_price} USD."
bitcoin_price_alert









