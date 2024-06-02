
function ingests {
curl -H 'Accept: application/vnd.twitchtv.v5+json' \
	-H 'Client-ID: $STREAM_KEY' \
	-X GET 'https://api.twitch.tv/kraken/ingests'
curl -H 'Accept: application/vnd.twitchtv.v5+json' \
	-H 'Client-ID: $ClientID' \
	-X GET 'https://api.twitch.tv/helix/videos?user_id=qroon26'

# Passing the access token to the API
#curl -X POST 'https://id.twitch.tv/oauth2/authorize?' -H 'Content-Type: application/x-www-form-urlencoded' -d "response_type=token&client_id=$ClientID&redirect_uri=http://localhost&scope=channel%3Amanage%3Apolls+channel%3Aread%3Apolls&state=c3ab8aa609ea11e793ae92361f002671"

ClientID="3j12owpmkavzdndag6aneyl3viy1z1"
ClientSecret="krisyhn52jtinfq3ef5gftc56xa2f7"
# First get access_token json string
access_token=$(curl -s -X POST 'https://id.twitch.tv/oauth2/token' -H 'Content-Type: application/x-www-form-urlencoded' \
	 -d "client_id=$ClientID&client_secret=$ClientSecret&grant_type=client_credentials&scope=user:edit+channel:manage:broadcast+user:read:broadcast+user:edit:broadcast+analytics:read:extensions" \
	 | json_pp | grep -e 'access_token' | awk '{print $3;}' | sed -e 's/\"//' -e 's/,//' -e 's/\"//')
# Second recover client_id which is the login related id 
client_id_num=$(curl -s -H 'Accept: application/vnd.twitchtv.v5+json' -\
	H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" \
	-X GET "https://api.twitch.tv/helix/users?login=qroon26" \
	| json_pp | grep -e 'id' | awk '{print $3;}' | sed -e 's/\"//' -e 's/,//' -e 's/\"//')

# List latest user videos
curl -s -H 'Accept: application/vnd.twitchtv.v5+json' \
	-H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" \
	-X GET "https://api.twitch.tv/helix/videos?user_id=$client_id_num" | json_pp | grep -e 'title'

newdescription="Feliz 13 de Julio."
curl -s  -X PUT "https://api.twitch.tv/helix/users?description=$newdescription"	 -H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID"
curl -X PATCH "https://api.twitch.tv/helix/channels?broadcaster_id=$client_id_num" \
	-H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" -H 'Content-Type: application/json' \
	--data-raw '{"game_id": "0", "title": "There be turtles", "broadcaster_language": "en"}'
curl -X PATCH "https://api.twitch.tv/helix/channels?broadcaster_id=$client_id_num" \
	-H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" -H 'Content-Type: application/json' \
	--data-raw '{"game_id": $gameid, "title": $title, "broadcaster_language": $broadcastlang}'

# Try to change -PATCH- the user motto (you'd need OAUTH for that)
curl -H "Authorization: Bearer $access_token" \
	-H "Client-Id: $ClientID" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-d "game_id=0&title=bananas" \
	-X PATCH "https://api.twitch.tv/helix/channels?broadcaster_id=$client_id_num"

curl -s -H 'Accept: application/vnd.twitchtv.v5+json' \
	-H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" \
	-X GET "https://api.twitch.tv/helix/users/extensions" | json_pp	
curl -s -H 'Accept: application/vnd.twitchtv.v5+json' \
	-H "Authorization: Bearer $access_token" -H "Client-Id: $ClientID" \
	-X GET "https://api.twitch.tv/helix/channels?broadcaster_id=$client_id_num" | json_pp
}
