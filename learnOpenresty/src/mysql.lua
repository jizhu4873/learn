local mysql = require("resty.mysql")
local db,err = mysql:new()
if not db then
    ngx.say("failed to instant mysql: ",err)
    return
end

db:set_timeout(1000) --1sec

local ok,err,errorcode,sqlstate = db:connect{
    host = "192.168.109.2",
    port = 3306,
    database = "hive",
    user = "root",
    password = "123456",
    charset = "utf8",
    max_packet_size = 1024*1024
}

if not ok then
    ngx.say("failed to connect :",err,"errorcode:",errorcode,"  ",sqlstate)
end

ngx.say("connected to mysql!")


local res, err, errcode, sqlstate =
db:query("drop table if exists cats")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

res, err, errcode, sqlstate =
db:query("create table cats "
        .. "(id serial primary key, "
        .. "name varchar(5))")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

ngx.say("table cats created.")

res, err, errcode, sqlstate =
db:query("insert into cats (name) "
        .. "values (\'hello\'),(\'world\'),(12)")
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end