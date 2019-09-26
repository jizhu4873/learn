<template>
    <div class="photo-container">
        <h4>{{photoDetail.title}}</h4>
        <div class="photo-subtitle">
            <span>发表时间：{{photoDetail.add_time}}</span>
            <span>点击：{{photoDetail.click}}</span>
        </div>
        <hr/>
        <div class="thumbs">
            <vue-preview :slides="slide1" @close="handleClose"></vue-preview>
        </div>
        <div class="photo-content">
            {{photoDetail.content}}
        </div>
        <comment :id="id"></comment>
    </div>
</template>

<script>
    import {Toast} from "mint-ui"
    import comment from "../subcomponent/comment.vue"
    export default {
        name: "photoDetail",
        components:{
            comment
        },
        data(){
            return {
                id:this.$route.params.id,
                photoDetail:{},
                slide1: [
                    {
                        src: 'https://farm6.staticflickr.com/5591/15008867125_68a8ed88cc_b.jpg',
                        msrc: 'https://farm6.staticflickr.com/5591/15008867125_68a8ed88cc_m.jpg',
                        alt: 'picture1',
                        title: '美图1',
                        w: 600,
                        h: 400
                    },
                    {
                        src: 'https://farm4.staticflickr.com/3902/14985871946_86abb8c56f_b.jpg',
                        msrc: 'https://farm4.staticflickr.com/3902/14985871946_86abb8c56f_m.jpg',
                        alt: 'picture2',
                        title: '美图2',
                        w: 1200,
                        h: 900
                    }
                ]
            }
        },
        methods:{
            getPhotoDetail(){
                //this.$axios.get("/getPhotoDetail/"+this.id).then(
                this.$axios.get("/getPhotoDetail/_id.json").then(
                    r=>{
                        if(r.data.status==0)
                            this.photoDetail=r.data.msg[0]
                        else
                            Toast("图片详情获取失败")
                    }
                )
            },
            handleClose () {
                console.log('closed preview of photos')
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
        .photo-content{
            line-height: 30px;
            font-size: 13px;
            margin-bottom: 20px;
        }
    }

</style>