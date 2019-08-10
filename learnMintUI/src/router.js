import VueRouter from 'vue-router'

import home from "./components/tabbar/home.vue"
import member from "./components/tabbar/member.vue"
import cart from "./components/tabbar/cart.vue"
import search from "./components/tabbar/search.vue"


// 3. 创建路由对象
var router = new VueRouter({
  routes: [
    {path:'/',redirect:'/home'},
    { path: '/home', component: home },
    { path: '/member', component: member },
    { path: '/cart', component: cart },
    { path: '/search', component: search }
  ],
  linkActiveClass:"mui-active"
})

// 把路由对象暴露出去
export default router