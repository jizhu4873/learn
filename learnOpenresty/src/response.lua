-- https://github.com/openresty/lua-nginx-module#ngxheaderheader
-- ngx.header.username="test"
-- ngx.header.multiVal={"val1","val2"}

-- 获取nginx的内置变量
ngx.say(ngx.var.server_port)

ngx.redirect("http://jd.com", 302)