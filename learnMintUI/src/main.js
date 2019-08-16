import Vue from "vue"
import VueRouter from "vue-router"
import router from "./router.js"
import axios from "axios"

import { Header,Swipe, SwipeItem } from 'mint-ui';

import "./lib/mui/css/mui.min.css"
import "./lib/mui/css/icons-extra.css"

import app from "./App.vue"

Vue.component(Header.name, Header);
Vue.component(Swipe.name, Swipe);
Vue.component(SwipeItem.name, SwipeItem);

Vue.use(VueRouter)

axios.defaults.baseURL = 'https://www.easy-mock.com/mock/5d564a4f1344716accd8c58f';
Vue.prototype.$axios=axios

var vm = new Vue({
    el:"#app",
    render:r=>r(app),
    router
})
