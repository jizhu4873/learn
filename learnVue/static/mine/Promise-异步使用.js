var fs = require("fs")

var p = new Promise(function(){
  fs.readFile("./vue-class.html","utf8",(err,suc)=>{
    if(err) throw err
    console.info(suc)
  })
})

