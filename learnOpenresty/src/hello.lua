ngx.say("<br/>----------------dev begin----------------<br/> ")
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

ngx.say("<br/><br/><br/>----------------others api for nginx ----------------<br/>")
ngx.say("http version ",ngx.req.http_version(),"<br/>")
ngx.say("http method ",ngx.req.get_method(),"<br/>")
ngx.say("raw headers ",ngx.req.raw_header(),"<br/>")

-- 必须提前读取，否则下面的get_body_data将无返回值
ngx.req.read_body()
ngx.say("body data ",ngx.req.get_body_data(),"<br/>")

local var = ngx.var.request_uri;
ngx.say("request_uri:",request_uri,"<br/>")
ngx.say("md5(123):",ngx.md5(123),"<br/>")




