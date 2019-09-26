<template>
    <ul class="mui-table-view">
        <li v-for="item in news" :key="item.id" class="mui-table-view-cell mui-media">
            <router-link :to="'/home/news/detail/'+item.id" class="">
                <img class="mui-media-object mui-pull-left" :src="item.img_url">
                <div class="mui-media-body">
                    <h4>{{item.title}}</h4>
                    <p class="mui-ellipsis">
                        <span>发表时间: {{item.add_time | dateFmt}}</span>
                        <span>点击: {{item.click}}次</span>
                    </p>
                </div>
            </router-link>
        </li>
    </ul>
</template>

<script>
    export default {
        name: "news",
        data(){
            return{
                news:[]
            }
        },
        methods:{
            getNews(){
                this.$axios.get("/getNews.json")
                    .then(r=>{
                        this.news=r.data.msg
                    })
            }
        },
        created() {
            this.getNews();
        }
    }
</script>

<style scoped lang="scss">
    .mui-media-body{
        h4{
            font-size: 14px;
            color: rgba(18, 11, 13, 0.74);
        }
    }
    .mui-ellipsis{
        display: flex;
        justify-content: space-between;
        span{
            color: #007aff;
            font-size: 12px;
        }
    }
</style>