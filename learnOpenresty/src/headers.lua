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

-- local headers = ngx.req.get_headers(0,true)
-- ngx.say(print_table(headers))

ngx.req.set_header("Foo", "Bar")

local res = ngx.location.capture("/index.html")

if res.status == ngx.HTTP_OK then
    ngx.say(res.body)
else
    ngx.exit(res.status)
end