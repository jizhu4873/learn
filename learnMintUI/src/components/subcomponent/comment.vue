<template>
   <div class="comment-container">
       <h4>发表评论</h4>
       <hr/>
       <textarea maxlength="120" placeholder="请输入要BB的内容(最多120字)" v-model="comment"></textarea>
       <mt-button type="primary" size="large" @click="postComment">发表评论</mt-button>
       <div class="comment-box">
           <div v-for="(d,i) in comments" :key="d.add_time" class="comment-item">
            <div class="comment-title">
               第{{i+1}}楼&nbsp;&nbsp;{{d.user_name}}&nbsp;&nbsp;发表时间:{{d.add_time|dateFmt}}
            </div>
            <div class="comment-content">
                {{d.content}}
            </div>
           </div>
       </div>
       <mt-button type="danger" plain size="large" @click="getMore">加载更多</mt-button>
   </div>
</template>

<script>
    import {Toast} from "mint-ui"
    export default {
        name: "comment",
        data(){
            return {
                comments:[],
                pageIndex:1,
                comment:""
            }
        },
        created(){
            this.getComments();
        },
        methods:{
            getComments(){
                //let url="/getComments/"+this.id+"?pageIndex="+this.pageIndex;
                let url="/getComments/_itemId.json?pageIndex="+this.pageIndex;
                this.$axios.get(url).then(r=>{
                    this.comments=this.comments.concat(r.data.msg);
                })
            },
            getMore(){
                this.pageIndex++;
                this.getComments();
            },
            postComment(){
                if(!this.comment){
                    return Toast("评论不能为空")
                }
                //this.$axios.post("/postComment/"+this.$route.params.id,{content:this.comment}).then(r=>{
                this.$axios.get("/postComment/_itemId.json").then(r=>{
                    this.comments.unshift({"user_name":"匿名用户","add_time":Date.now(),"content":this.comment})
                })
            }
        },
        props:["id"]
    }
</script>

<style scoped lang="scss">
    .comment-container{
        h4{
            font-size: 16px;
        }
        .comment-box{
            margin: 5px 0;
            .comment-item{
                .comment-title{
                    line-height: 35px;
                    background: #cccccc;
                }
                .comment-content{
                    line-height: 35px;
                    text-indent: 2em;
                }
            }
        }

    }
</style>