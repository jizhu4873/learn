--[[local var = ngx.req.read_body()
local data = ngx.req.get_body_data()
ngx.say("content reading from sub-capture :"..data)]]


function print_array(tab)
    local str = ''
    for _,v in pairs(tab) do
        str = str .. ' ' .. tostring(v) .. '\r\n'
    end
    return str
end

ngx.say(print_array(ngx.req.get_uri_args()))