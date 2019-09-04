local json = require("cjson")

local function format_table(t)
    local str = ''
    for k,v in pairs(t) do
        str = str .. k .. '--'..v..'\r\n'
    end
    return str
end

local str_json = '{"key":"this is key","val":"this is val","num":1}'

ngx.say(format_table(json.decode(str_json)))

ngx.say("\r\n"..json.encode(json.decode(str_json)))

-- lua json语句
local j = {color={"red","green","black"},weight=80}

ngx.say(json.encode(j))

-- json 转换空数组
json.encode_empty_table_as_object(false) -- true 则不为数组
ngx.say(json.encode({}))
