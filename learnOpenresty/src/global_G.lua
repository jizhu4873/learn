require("/src/tab_obj")
-- 全局变量G
local function format_tab(t)
    local str = ""

    for key,_ in pairs(t) do
        str = str .. key ..":"..type(_).."<hr/>"
    end
    return str
end

-- ngx.say(format_tab(getmetatable(_G).__index))
ngx.say(format_tab(_G))