<template>
   <div>
       <!--轮播图-->
       <mt-swipe :auto="1000">
           <mt-swipe-item v-for="item in lunbos" :key="item.img">
               <img :src="item.img">
           </mt-swipe-item>
       </mt-swipe>

       <!--六宫格-->
       <ul class="mui-table-view mui-grid-view mui-grid-9">
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
               <router-link to="/home/news">
                   <img src="../../images/menu1.png">
                   <div class="mui-media-body">新闻资讯</div>
               </router-link>
           </li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="#">
               <img src="../../images/menu2.png">
               <div class="mui-media-body">图片分享</div></a></li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="#">
               <img src="../../images/menu3.png">
               <div class="mui-media-body">商品购买</div></a></li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="#">
               <img src="../../images/menu4.png">
               <div class="mui-media-body">留言反馈</div></a></li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="#">
               <img src="../../images/menu5.png">
               <div class="mui-media-body">视频专区</div></a></li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="#">
               <img src="../../images/menu6.png">
               <div class="mui-media-body">练习我们</div></a></li>
       </ul>
   </div>
</template>

<script>
    export default {
        name: "home",
        data(){
            return {lunbos:[]}
        },
        methods:{
            getLunbo(){
                this.$axios
                    .get('/lunbo')
                    .then(res => (this.lunbos=res.data.data))
                    .catch(function (error) {
                        console.log(error);
                    });
            }
        },
        created() {
            this.getLunbo();
        }
    }
</script>

<style lang="scss" rel="stylesheet/scss" scoped>
    .mint-swipe{
        height: 200px;
        .mint-swipe-item{
            &:nth-child(1){
                background-color: #94ff9d;
            }
            &:nth-child(2){
                background-color: #b1ffd4;
            }
            &:nth-child(3){
                background-color: #d7ff78;
            }
            img{
                width: 100%;
                height: 100%;
            }
        }
    }

    .mui-grid-view.mui-grid-9{
        background-color:#fff;
        .mui-media-body{
            font-size: 14px;
        }
    }
    .mui-grid-view.mui-grid-9 .mui-table-view-cell{
        border-right: none;
        border-bottom: none;
        img{
            height: 60px;
            width: 60px;
        }
    }
</style>