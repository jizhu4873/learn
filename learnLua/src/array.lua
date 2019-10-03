arr = {1,2.0,3.5,"4",{1,2},{name="tom"}}

table.insert(arr,table.maxn(arr)+1,{"a","b"})

for i, v in pairs(arr) do
    if type(v) == "table" then
        for ii, vv in pairs(v) do
            print(ii,vv)
        end
    else
        print(i,v)
    end
end