<template>
    <div class="desc-box">
        <h3>{{desc.title}}</h3>
        <hr>
        <div class="content" v-html="desc.content"></div>
    </div>
</template>

<script>
    export default {
        name: "goodsDesc",
        data(){
            return {
                desc:{}
            }
        },
        methods:{
            get(){
                //this.$axios.get("/goods/desc/"+this.$route.params.id).then(
                this.$axios.get("/goods/desc.json").then(
                    r=>{
                        console.info(r)
                        if(r.data.status==0)
                            this.desc=r.data.msg[0];
                    }
                )
            }
        },
        created() {
           this.get()
        }
    }
</script>

<style scoped lang="scss">
    .desc-box{
        h3{
            font-size: 16px;
            color: #0062cc;
            text-align: center;
            margin: 15px 0;
        }
        .content{
            img{
                width: 100%;
                padding: 5px;
            }
        }
    }
</style>