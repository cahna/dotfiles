#!/usr/bin/env luajit

local io    = require 'io'
local http  = require 'socket.http'
local ltn12 = require 'ltn12'
local json  = require 'cjson'

local h = {
  ['User-Agent']      = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36',
  ['Accept']          = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  ['Accept-Language'] = 'en-US,en;q=0.8',
  ['Cache-Control']   = 'max-age=0',
  ['Connection']      = 'keep-alive',
  ['DNT']             = 1,
  ['Referer']         = 'http://stackoverflow.com/questions/11658490/grab-ip-address-from-google-via-json-export'
}

local url      = 'http://jsonip.com/'
local response = {}
local save     = ltn12.sink.table(response)

local ok, code, headers = http.request({ 
    url = url,
    sink = save,
    headers = h
})

if not ok or code ~= 200 then
  print('error: '..(code or 'nil'))
  os.exit(0)
end

response_body = response[1]
 
-- convert from json to lua object
decoded = json.decode(response_body)

if decoded == nil or decoded.ip == nil or type(decoded.ip) ~= 'string' then
  print('error: decode')
  os.exit(0)
elseif type(decoded.ip) == 'string' and decoded.ip:len() < 20 then
  print(decoded.ip)
end

