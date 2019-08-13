var fs = require("fs");

function getFileContent(path) {
    var p = new Promise((resolve,reject) =>{
        fs.readFile(path,"utf8",((err, data) => {
            if(err) return reject(err)
            resolve(data)
        }))
    })
    return p;
}

getFileContent("../../learn-nodejs.iml0")
    .then(data=>console.info(data),err=>console.error(err))