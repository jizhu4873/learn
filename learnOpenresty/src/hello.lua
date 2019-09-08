--[[ngx.sleep(1)]]


--[[require("resty.core");
local mobdebug = require("debug.mobdebug");
mobdebug.start();
]]

local str = "hello"
ngx.header.hello='world'
ngx.say(str)