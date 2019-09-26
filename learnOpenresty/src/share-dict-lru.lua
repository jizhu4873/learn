local cache = ngx.shared.ngx_cache

for index=1,10000 do
    local succ, err, forcible = cache:set(tostring(index),string.rep("a",57))
end

local keys = cache:get_keys(0)
ngx.say(#keys)

local var = cache:get("1")
ngx.say(var)

-- 内存不足
suc,err,forc = cache:set("100001",string.rep("s",1000," "))
ngx.say(forc)