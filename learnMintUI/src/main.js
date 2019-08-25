import Vue from "vue"
import VueRouter from "vue-router"
import router from "./router.js"
import axios from "axios"
import moment from "moment" //时间插件

import { Header,Swipe, SwipeItem ,Button,Lazyload } from 'mint-ui';

import "./lib/mui/css/mui.min.css"
import "./lib/mui/css/icons-extra.css"

import app from "./App.vue"

Vue.component(Header.name, Header);
Vue.component(Swipe.name, Swipe);
Vue.component(SwipeItem.name, SwipeItem);
Vue.component(Button.name, Button);

Vue.use(VueRouter)
Vue.use(Lazyload)

 Vue.filter("dateFmt",(dateStr,pattern="YYYY-MM-DD HH:mm")=>{
     return moment(dateStr).format(pattern)
 })

axios.defaults.baseURL = 'https://www.easy-mock.com/mock/5d564a4f1344716accd8c58f';
Vue.prototype.$axios=axios

var vm = new Vue({
    el:"#app",
    render:r=>r(app),
    router
})
