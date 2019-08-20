<template>
   <div class="comment-container">
       <h4>发表评论</h4>
       <hr/>
       <textarea maxlength="120" placeholder="请输入要BB的内容(最多120字)"></textarea>
       <mt-button type="primary" size="large">发表评论</mt-button>
       <div class="comment-box">
           <div v-for="(d,i) in comments" :key="d.add_time" class="comment-item">
            <div class="comment-title">
               第{{i+1}}楼&nbsp;&nbsp;{{d.user_name}}&nbsp;&nbsp;发表时间:{{d.add_time}}
            </div>
            <div class="comment-content">
                {{d.content}}
            </div>
           </div>
       </div>
       <mt-button type="danger" plain size="large">加载更多</mt-button>
   </div>
</template>

<script>
    export default {
        name: "comment",
        data(){
            return {
                comments:[],
                pageIndex:1
            }
        },
        created(){
            this.getComments();
        },
        methods:{
            getComments(){
                let url="/getComments/"+this.id+"?pageIndex="+this.pageIndex;
                console.info("======="+url)
                this.$axios.get(url).then(r=>{
                    this.comments=r.data.msg;
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