local shared_data = ngx.shared.my_shared_data;

local i = shared_data:get("i")
ngx.say("init i (",i,")<br/>")
if not i then
    i = 1
    shared_data:set("i",i)
    ngx.say("nazy set i (",i,")<br/>")
end

i = shared_data:incr("i", 1)
ngx.say("increased i (",i,")<br/>")
