local json = require "cjson"
ngx.req.read_body()
local data = ngx.req.get_post_args()

if not data then
    ngx.exit(ngx.HTTP_NOT_FOUND)
end

local info = ngx.decode_base64(data.info)
local ip = ngx.var.remote_addr
local agent = ngx.req.get_headers()["user-agent"] or "postman"
local resp = {}
resp.info = info
resp.ip = ip
resp.agent = agent
ngx.say(json.encode(resp))

