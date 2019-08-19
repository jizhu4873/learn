<template>
   <div class="comment-container">
       <h4>发表评论</h4>
       <hr/>
       <textarea maxlength="120" placeholder="请输入要BB的内容(最多120字)"></textarea>
       <mt-button type="primary" size="large">发表评论</mt-button>
       <div class="comment-box">
           <div class="comment-item">
            <div class="comment-title">
               第1楼&nbsp;&nbsp;匿名用户&nbsp;&nbsp;发表时间:2019-8-19 14:46:28
            </div>
            <div class="comment-content">
                今风尘碌碌，一事无成
            </div>
           </div>
       </div>
       <mt-button type="danger" plain size="large">加载更多</mt-button>
   </div>
</template>

<script>
    export default {
        name: "comment"
    }
</script>

<style scoped lang="scss">
    .comment-container{
        h4{
            font-size: 16px;
        }

    }
</style>