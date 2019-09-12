<template>
   <div>
       <!--轮播图-->
        <lunbotu :lunbos="lunbos" :is-full="true"></lunbotu>

       <!--六宫格-->
       <ul class="mui-table-view mui-grid-view mui-grid-9">
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
               <router-link to="/home/news">
                   <img src="../../images/menu1.png">
                   <div class="mui-media-body">新闻资讯</div>
               </router-link>
           </li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
               <router-link to="/home/photos">
               <img src="../../images/menu2.png">
               <div class="mui-media-body">图片分享</div>
               </router-link></li>
           <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
               <router-link to="/home/goods/list">
                <img src="../../images/menu3.png">
                <div class="mui-media-body">商品购买</div>
               </router-link>
           </li>
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
    import Lunbotu from "../subcomponent/lunbotu.vue";
    export default {
        name: "home",
        components: {Lunbotu},
        data(){
            return {
                lunbos:[]
            }
        },
        methods:{
            getLunbo(){
                this.$axios
                    .get('lunbo.json')
                    .then(res => {this.lunbos=res.data.msg})
                    .catch(function (error) {
                        console.log(error);
                    });
            }
        },
        created() {
            this.getLunbo();
            //this.lunbos=require("../../data/lunbo.json").msg
        }
    }
</script>

<style lang="scss" rel="stylesheet/scss" scoped>
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