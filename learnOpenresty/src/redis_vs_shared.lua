local redis = require "resty.redis"
local red = redis:new()
red:set_timeouts(1000, 1000, 1000) -- 1 sec
local ok, err = red:connect("192.168.109.2", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end


function set_to_cache(key,val,expire)
    if not expire then
        expire = 0
    end
    local ngx_cache = ngx.shared.ngx_cache
    local suc,err,forcible = ngx_cache:set(key, val, expire)
    return suc
end

function get_from_cache(key)
    local ngx_cache = ngx.shared.ngx_cache
    local val = ngx_cache:get(key)
    if not val then
        val = get_from_redis(key)
        set_to_cache(key,val)
    end
    return val
end

function get_from_redis(key)
    local res, err = red:get(key)
    if res then
        return res
     else
        return "err"
    end
end

local res = get_from_redis("dog")
-- local res = get_from_cache("dog")
ngx.say(res)