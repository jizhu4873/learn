-- 函数闭包
function Person(name)
    local self = {}
   function init()
       self.name = name
   end

    self.sayHi = function()
        print("hi "..name)
    end

    init()
    return self
end

local p = Person("tom")
p:sayHi()

-- 实现继承
function Man(name)
    local self = Person(name)
    -- 方法拓展
    self.sayHello=function()
        print("hello "..self.name)
    end
    return self
end

local m = Man("jessy")
m:sayHi()
m:sayHello()