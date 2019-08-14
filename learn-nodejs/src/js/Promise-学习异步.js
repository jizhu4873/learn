var fs = require("fs");

function getFileContent(path) {
    var p = new Promise((resolve,reject) =>{
        fs.readFile(path,"utf8",((err, data) => {
            if(err) return reject(err)
            return resolve(data)
        }))
    })
    return p;
}

getFileContent("../../learn-nodejs.iml")
    .then(
        data=>{
            console.info(data)
            return getFileContent("../../package.json0")
        }
     ).then(data=>{
            console.info(data)
        }
    ).catch(err=>console.info("自己报的错误："+err.message))