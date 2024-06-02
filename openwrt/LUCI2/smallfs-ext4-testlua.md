# Register it in uhttpd using

	option lua_prefix '/app'
	option lua_handler '/root/simple-app.lua'


File /www/test.html

<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="refresh" content="0; URL=cgi-bin/test/test/" />
</head>
<body style="background-color: white">
<a href="cgi-bin/test/test/">Test</a>
</body>
</html>

Folder /www/cgi-bin/test/
Path to cgi, as defined in uHTTPd configuration, is /www/cgi-bin/ .
As I want to separate my files from those of LuCI, I create this new subfolder.
File test, called by test.html, is in this folder.
It is a simple menu offering links to the other two pages. One visualizes the current environment of uHTTPd. The other show how to get the variables passed by a GET

File /www/cgi-bin/test/test

#!/usr/bin/lua

local util = require "test/testutil"

print ("Content-type: Text/html\n\r")
util.printFile( 'test-top' )
print( '<h2>Test Menu</h2>' )
print( '<div>' )
print( '<p><a href="/cgi-bin/test/testget/">' )
print( 'Get current environment table</a></p>' )
print( '<p><a href="/cgi-bin/test/testgetqs/?var1=one&var2=two">' )
print( 'Get query string</a></p>' )
print( '</div>' )
util.printFile( 'test-bottom' )

File /www/cgi-bin/test/testget

#!/usr/bin/lua

local util = require "test/testutil"
nixio = require "nixio"

print ("Content-type: Text/html\n\r")
util.printFile( 'test-top' )
print( '<h2>Get the current environment table</h2>' )
print( '<a href="/cgi-bin/test/test/">Back to menu</a>' )
local envtable = nixio.getenv()
for k,v in pairs( envtable ) do
  print( '<p>'..k..' : '..v..'</p>' )
end
print( '<a href="/cgi-bin/test/test/">Back to menu</a>' )
util.printFile( 'test-bottom' )

File /www/cgi-bin/test/testgetqs

#!/usr/bin/lua

local util = require "test/testutil"
nixio = require "nixio"

print ("Content-type: Text/html\n\r")
util.printFile( 'test-top' )
print( '<h2>Get the current query string</h2>' )
local query = nixio.getenv( 'QUERY_STRING' )
print( '<p>QUERY_STRING : "' .. query .. '"</p>' )
print( '<p>Value of var1 : "' .. util.getValQuery( 'var1' ) .. '"</p>' )
print( '<p>Value of var2 : "' .. util.getValQuery( 'var2' ) .. '"</p>' )
print( '<p>Value of var3 : "' .. util.getValQuery( 'var3' ) .. '"</p>' )
print( '<a href="/cgi-bin/test/test/">Back to menu</a>' )
util.printFile( 'test-bottom' )

Folder /usr/lib/lua/test/
Folder /usr/lib/lua/ is one of the folders where are stored lua's modules.
For the same reason as before, I create a subfolder where will be stored my modules and other files.
Module testutil.lua include two functions:

    testutil.printFile used to print common parts of web pages. They are stored in files test-top and test-bottom and include html and ccs code.
    testutil.getValQuery used to extract the value of a variable (used in testgetqs)

File /usr/lib/lua/test/testutil.lua

local testutil = {}

local io = require "io"
local nixio = require "nixio"

-- print file 'filename' located in the same folder /usr/lib/lua/test/

testutil.printFile = function( filename )
  local f = io.open( '/usr/lib/lua/test/' .. filename, "r" )
  if f == nil then
    print( "<p>Can't open " .. filename .. "</p>" )
  else
    local line = f:read()
    while line ~= nil do
      print( line )
      line = f:read()
   end
    f:close()
  end
end

-- Get the value of a query variable 'varname'

testutil.getValQuery = function( varname )
  local value
  local query = nixio.getenv( 'QUERY_STRING' )
  if query ~= nil then
    query = '&' .. query
    varname = '&' .. varname .. '='
    local p, q = string.find( query, varname )
    if q ~= nil then
      p = string.find( query, '&', q )
      if p == nil then p = -1 else p = p - 1 end
      value = string.sub( query, q + 1, p )
    end
  end
  value = value or 'No such variable'
  return value
end

return testutil

File /usr/lib/lua/test/test-top

<html>
  <head>
    <style rel='stylesheet' type='text/css'>
      body {
        background-color: Beige; color: DarkGreen;
        font-family:'DejaVu Sans', Helvetica, sans-serif;
      }
      h1 { font-size:6vh; text-align:center; color: Navy; }
      h2 { font-size:4vh; text-align:center; color: Navy; }
    </style>
    <title>An example</title>
    <meta charset="utf-8">
  </head>
  <body>
    <h1>Example of using Lua under uhttpd</h1>

File /usr/lib/lua/test/test-bottom

    <p style='font-size:4vh; text-align:center; color: Navy;'>
      by J-M Gallego
    </p>
  </body>
</html>

