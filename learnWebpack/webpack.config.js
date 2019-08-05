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
            },
            {
                test:/\.scss$/,
                use:["style-loader","css-loader","sass-loader"]
            },
            {
                test:/(jpg|png|jpeg|bmp|gif)$/,
                use:["url-loader?limit=1024*1024&name=[hash:8]-[name].[ext]"] //图片超过限定则不编码，文件名保持不变通过hash防止重名
            },
            {
                test:/(ttf|eot|svg|woff|woff2)$/,
                use:["url-loader"]
            },
            {  //解析es6，es7高级语法，需排除node_modules的js文件
                test:/\.js$/,use:["babel-loader"],exclude:/node_modules/
            }
        ]
    }
}