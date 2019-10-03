person = {
    name="张飞",
    age=28
}

person.sex="male"
person["height"]=180
person['weight']=55

for i, v in pairs(person) do
    print(i,v)
end