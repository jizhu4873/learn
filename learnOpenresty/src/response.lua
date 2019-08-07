-- https://github.com/openresty/lua-nginx-module#ngxheaderheader
-- ngx.header.username="test"
-- ngx.header.multiVal={"val1","val2"}

-- 获取nginx的内置变量
-- ngx.say(ngx.var.server_port)

-- redirect前面不能出现say/print等方法
-- ngx.redirect("https://music.163.com")

-- return ngx.exit(404)
count = count +1
ngx.say("count:",count)
local shared = ngx.shared.my_shared_data;
shared:incr("count",2)
ngx.say("<br/>count from shared_dict :",shared:get("count"))
