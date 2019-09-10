import VueRouter from 'vue-router'

import home from "./components/tabbar/home.vue"
import member from "./components/tabbar/member.vue"
import cart from "./components/tabbar/cart.vue"
import search from "./components/tabbar/search.vue"
import news from "./components/news/news.vue"
import detail from "./components/news/detail.vue"
import photos from "./components/photos/index.vue"
import photo from "./components/photos/photoDetail.vue"
import goodsList from "./components/goods/goodsList.vue"
import goodsInfo from "./components/goods/goodsInfo.vue"
import goodsDesc from "./components/goods/goodsDesc.vue"
import goodsComment from "./components/goods/goodsComment.vue"


// 3. 创建路由对象
var router = new VueRouter({
  routes: [
    {path:'/',redirect:'/home'},
    { path: '/home', component: home },
    { path: '/member', component: member },
    { path: '/cart', component: cart },
    { path: '/search', component: search },
    {path:'/home/news',component:news},
    {path:'/home/news/detail/:id',component:detail},
    {path:'/home/photos',component:photos},
    {path:'/home/photo/:id',component:photo},
    {path:'/home/goods/list',component:goodsList},
    {path:'/home/goods/:id',component:goodsInfo,name:"goodsinfo"},
    {path:'/home/goods/desc/:id',component:goodsDesc,name:"goodsDesc"},
    {path:'/home/goods/comment/:id',component:goodsComment,name:"goodsComment"}
  ],
  linkActiveClass:"mui-active"
})

// 把路由对象暴露出去
export default router