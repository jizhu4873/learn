-- 直接与tcp协议层的数据进行交互

local tcp,err = ngx.socket.tcp()

if err then
    ngx.say("err => "..err)
else
    tcp:settimeout(5000)
    local ok,err1 = tcp:connect("192.168.109.2", 22)
    if ok then
        ngx.say("ok => "..ok)
    else
        ngx.say("err1 => "..err1)
    end

    local counts,err = tcp:send("hello")
    ngx.say(counts)
end