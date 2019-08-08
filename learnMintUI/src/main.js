import Vue from "vue"
import VueRouter from "vue-router"
import router from "./router.js"
import { Header } from 'mint-ui';

import "./lib/mui/css/mui.min.css"
import "./lib/mui/css/icons-extra.css"

import app from "./App.vue"

Vue.component(Header.name, Header);
Vue.use(VueRouter)

var vm = new Vue({
    el:"#app",
    render:r=>r(app),
    router
})