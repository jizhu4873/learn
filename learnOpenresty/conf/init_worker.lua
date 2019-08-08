local count = 0
local delayInSec = 3
local heartbeat = nil

heartbeat = function(args)
    count = count + 1
    ngx.log(ngx.ERR,"print count :",count,"during init worker...")

    local ok,err = ngx.timer.at(delayInSec, heartbeat)

    if not ok then
        ngx.log(ngx.ERR,"setting up timed task failed during init worker...",err)
    end
end

heartbeat()