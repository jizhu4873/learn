import Vue from "vue"
import { Header } from 'mint-ui';

import "./lib/mui/css/mui.min.css"
import app from "./App.vue"

Vue.component(Header.name, Header);

var vm = new Vue({
    el:"#app",
    render:r=>r(app)
})