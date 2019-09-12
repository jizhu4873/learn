import Vue from "vue"
import VueRouter from "vue-router"
import router from "./router.js"
import axios from "axios"
import moment from "moment" //时间插件
import VuePreview from 'vue-preview'

import MintUI from 'mint-ui';

import "./lib/mui/css/mui.min.css"
import "./lib/mui/css/icons-extra.css"
import 'mint-ui/lib/style.css'

import app from "./App.vue"



Vue.use(VueRouter)
Vue.use(MintUI)
Vue.use(VuePreview)

 Vue.filter("dateFmt",(dateStr,pattern="YYYY-MM-DD HH:mm")=>{
     return moment(dateStr).format(pattern)
 })

//axios.defaults.baseURL = 'https://www.easy-mock.com/mock/5d564a4f1344716accd8c58f';
axios.defaults.baseURL = '/static/data/';
Vue.prototype.$axios=axios

var vm = new Vue({
    el:"#app",
    render:r=>r(app),
    router
})
