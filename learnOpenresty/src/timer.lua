local delay = 3
local index = 0
local invoke

invoke = function(premature,param)
    if premature then
        return
    end
    ngx.log(ngx.ERR,"param is "..param)
    index = 1+index
    ngx.timer.at(delay,invoke,"hello timer"..index)
end

local ok,err = ngx.timer.at(delay,invoke,"hello timer")