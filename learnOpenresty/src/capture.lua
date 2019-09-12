function print_table(table)
    local function parse_arr(key,tab)
        local str = ''
        for _,v in pairs(tab) do
            str = str..key.." -> "..v.."\r\n"
        end
        return str
    end

    local str = ''
    for k,v in pairs(table) do
        if type(v) == 'table' then
            str = str..parse_arr(k,v)
        else
            str = str..k.." -> "..(v).."</br>"
        end
    end
    return str
end


--[[
ngx.req.set_header("Foo", {"Bar","ZWM"})
ngx.req.set_header("User-Agent",nil)

local res = ngx.location.capture("/headers")

if res.status == ngx.HTTP_OK then
    ngx.say(res.body)
else
    ngx.exit(res.status)
end

]]
local var = ngx.req.read_body()
local data = ngx.req.get_body_data()
local res = ngx.location.capture('/app/sub-capture?sex=male', { args = { name = "zwm", age = 31 } })

ngx.say(res.body)
