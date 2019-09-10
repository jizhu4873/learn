local var = ngx.req.read_body()
local data = ngx.req.get_body_data()
ngx.say("content reading from sub-capture :"..data)