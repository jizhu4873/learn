Person = {}
Person.sayHello = function(self)
    print("hello ,"..self.name.." !")
end

Person.new = function(name)
    local self = clone(Person)
    self.name = name
    return self
end
function clone(obj)
    local o = {}
    for i, v in pairs(obj) do
       o[i]=v
    end
    return o
end

local p = Person.new("jerry")
p.sayHello(p)
p:sayHello()

print("--------------------- 对象继承")
function copy(dest,source)
    for i, v in pairs(source) do
        dest[i]=v
    end
end
Man = {}
Man.manSayHello=function()
    print("man say hello")
end

Man.sayHello=function(self)
    print("man said '"..self.name.."'")
end
Man.new = function(name)
    local self = Person.new(name)
    copy(self,Man)
    return self
end


local man = Man.new("tom")
man:sayHello()
man:manSayHello()