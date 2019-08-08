local args = ngx.req.get_uri_args()
local i = args["i"] or 10
local j = args["j"] or 10
return i+j