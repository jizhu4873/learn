local var = ngx.var
ngx.say("first parameter is ",var.firstParam,"</br>")
ngx.say("second parameter is ",var.secondParam,"</br>")
ngx.say("second parameter is ",var[2],"(in the type of var[2])</br>")
-- 请求头
ngx.say("<br/><br/><br/>----------------req headers begin----------------<br/> ")
local headers = ngx.req.get_headers()
ngx.say("headers[Host]:",headers['host'],"<br>")
ngx.say("headers[user-agent]:",headers['user-agent'],"<br>")
ngx.say("headers.user_agent:",headers.user_agent,"<br>")
for k,v in pairs(headers) do
    if type(v) == 'type' then
        ngx.say(k,":",table.concat(v,"、"),"<br/>")
    else
        ngx.say(k,":",v,"<br/>")
    end
end

ngx.say("<br/><br/><br/>----------------uri args begin----------------<br/> ")
local uriArgs = ngx.req.get_uri_args()
for k,v in pairs(uriArgs) do
    if(type(v) == "table") then
        ngx.say(k,":",table.concat(v,"、"),"<br/>")
    else
        ngx.say(k,":",v,"<br/>")
    end
end

ngx.say("<br/><br/><br/>----------------uri args end----------------<br/>")