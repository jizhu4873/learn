<template>
    <div class="photo-container">
        <h4>{{photoDetail.title}}</h4>
        <div class="photo-subtitle">
            <span>发表时间：{{photoDetail.add_time}}</span>
            <span>点击：{{photoDetail.click}}</span>
        </div>
        <hr/>
        <div class="photo-content">
            {{photoDetail.content}}
        </div>
    </div>
</template>

<script>
    import {Toast} from "mint-ui"
    export default {
        name: "photoDetail",
        data(){
            return {
                id:this.$route.params.id,
                photoDetail:{}
            }
        },
        methods:{
            getPhotoDetail(){
                this.$axios.get("/getPhotoDetail/"+this.id).then(
                    r=>{
                        if(r.data.status==0)
                            this.photoDetail=r.data.msg[0]
                        else
                            Toast("图片详情获取失败")
                    }
                )
            }
        },
        created() {
            this.getPhotoDetail()
        }
    }
</script>

<style scoped lang="scss">
    .photo-container{
        padding: 6px;
        h4{
            margin: 10px 0;
            text-align: center;
            color: #1ac3cc;
        }
        .photo-subtitle{
            display: flex;
            justify-content: space-between;
        }
    }

</style>