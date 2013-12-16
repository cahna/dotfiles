#!/bin/sh

url=http://jsonip.com/
ua='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36'
accept='text/json,text/*'
alang='en-US'
cache='max-age=0'
conn='keep-alive'
refer='http://stackoverflow.com/questions/11658490/grab-ip-address-from-gooogle-via-json-export'

curl -f -s -e "$refer" -A "$ua" -H "Accept: $accept" -H "Accept-Language: $alang" -H "DNT: 1" $url \
  | jq -r '.ip'

