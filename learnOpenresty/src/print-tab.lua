local tab = require "./src/tab_obj"

local t = {a=1,b=2}
local function format_tab(t)
    local str = ""

    for key,_ in pairs(t) do
        str = str .. key .."<hr/>"
    end
    return str
end

ngx.say(format_tab(t))
ngx.say("<br/>"..format_tab(tab))