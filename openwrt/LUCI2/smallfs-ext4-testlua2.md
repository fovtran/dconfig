Given these basic building blocks you can now start doing RESTy stuff:

    env.PATH_INFO refers to the relative path portion after option lua_prefix (/app in our example)
    env.REQUEST_METHOD contains the HTTP method used for requesting, e.g. GET, POST, PUT etc.
    to set the response HTTP status, use the Status pseudo header: send("Status: 503 Server Error\r\n\r\n")
    to set the response content type, send a Content-Type header: send("Content-Type: application/json; charset=UTF-8\r\n")
    to terminate the header block and start with content, send a sole \r\n or end the last header with \r\n\r\n: send("X-Foobar: 1\r\n\r\n") or send("\r\n")
    to quickly serialize JSON, you can use LuCI's jsonc library binding 42: require "luci.jsonc"; send(luci.jsonc.stringify({ some = { complex = { data = "structure", foo = true, bar = { 1, 2, 3 } } } }))

 

Btw, Lua has some interesting string quoting possibilities which help to unclutter your code. You can wrap your strings in [[ and ]] which will act like double quotes. Using these, your example above would become:


