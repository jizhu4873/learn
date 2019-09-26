<template>
    <div class="detail-container">
        <h4 class="title">{{detail.title}}</h4>
        <p class="subtitle">
            <span>发表时间:{{detail.add_time}}</span>
            <span>点击: {{detail.click}} 次</span>
        </p>
        <hr/>
        <div class="detail" v-html="detail.content"></div>
        <comment-box :id="id"></comment-box>
    </div>
</template>

<script>
    import comment from "../subcomponent/comment.vue"

    export default {
        name: "detail",
        data(){
            return {
                id:this.$route.params.id,
                detail:{}
            }
        },
        created() {
            this.getDetail();
        },
        methods:{
            getDetail(){
                //this.$axios.get("news/getDetail/"+this.id).then(r=>{
                this.$axios.get("news/getDetail/_id.json").then(r=>{
                    this.detail = r.data.msg[0]
                })
            }
        },
        components:{
            "comment-box":comment
        }
    }
</script>

<style lang="scss">
  .detail-container{
      padding: 0 4px;
      .title{
          margin: 15px auto;
          color: rgba(245, 75, 75, 0.49);
          text-align: center;
          font-size: 16px;
      }
      .subtitle{
          color: #0062cc;
          display: flex;
          justify-content: space-between;
      }
      .detail{
          .img-container{
              img{
                  width: 100%;
              }
          }
      }
  }
</style>