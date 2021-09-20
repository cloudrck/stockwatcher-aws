require './lib/rest_ally/ally_api'


myoptions = {
    :consumer_key => ENV["CONSUMER_KEY"],
    :consumer_secret => ENV["CONSUMER_SECRET"],
    :access_key     => ENV["ACCESS_TOKEN"],
    :access_key_secret  => ENV["ACCESS_TOKEN_SECRET"]
  }
aaws = RestAlly::AllyApi.new(myoptions)

doc1_load = aaws.account(:holdings, { :id => ENV["ALLY_ACCOUNT"] })
#pp doc1_load['accountholdings']['holding']
#pp doc1_load
output = File.open("/opt/outputfile.json","w")
output.write Oj.dump(doc1_load)
output.close

#pp doc["accounts"]['accountsummary']['account']
#pp doc('/response/accounts/accountsummary/accountbalance')