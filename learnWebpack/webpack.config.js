const path = require("path")

module.exports={
    entry:path.join(__dirname,"./src/main.js"),
    output:{
        path:path.join(__dirname,"./dist"),
        filename:"bundle.js"
    },
    plugins:[],
    module:{
        rules:[
            {
                test:/\.css$/ //test表示正则匹配
                ,use:["style-loader","css-loader"] //loader调用顺序（从后往前最后抛给webpack）
            },
            {
                test:/\.less$/,
                use:["style-loader","css-loader","less-loader"]
            }
        ]
    }
}