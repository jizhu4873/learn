import $ from "jquery"

import "./css/index.css"
import "./css/index.less"

$(function () {
    $("li:odd").css("backgroundColor","rgba(121,255,131,0.39)")
    $("li:even").css("backgroundColor",function () {
        return "#69ff7e"
    })
})
