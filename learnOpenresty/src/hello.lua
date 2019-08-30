--[[ngx.sleep(1)]]

--[[
ngx.req.set_header("Connection", "close")
ngx.say("hello world")
ngx.say(ngx.worker.pid())]]
require("resty.core");
local mobdebug = require("debug.mobdebug");
mobdebug.start();

local str = "hello"
+
ngx.say(str)