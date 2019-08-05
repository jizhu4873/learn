// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
/*Vue.use(ElementUI);*/

import Vue from "vue"
import VueRouter from "vue-router"
Vue.use(VueRouter)


import login,{name as nm} from "./login"

Vue.config.productionTip = false

console.log(nm)
/* eslint-disable no-new */
/*
new Vue({
  el: '#app',
  render: h => h(App),
  router,
  components: { App },
  template: '<App/>'
})
*/

new Vue({
  el:"#app",
  render:r=>r(login)
})
