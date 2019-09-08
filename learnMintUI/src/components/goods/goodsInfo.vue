<template>
    <div class="goods-container">
        <lunbo :lunbos="lunbos" :is-full="false"></lunbo>

        <div class="mui-card">
            <div class="mui-card-header">
                商品标题
            </div>
            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    <p class="price">
                        市场价：<del>￥2899</del>&nbsp;&nbsp;<span>销售价：￥2699</span>
                    </p>
                        购买数量：
                    <div class="mui-numbox" data-numbox-min='1' data-numbox-max='9'>
                        <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
                        <input id="test" class="mui-input-numbox" type="number" value="5" />
                        <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
                    </div>
                    <mt-button type="primary" size="small">立刻购买</mt-button>
                    <mt-button type="danger" size="small">加入购物车</mt-button>
                </div>
            </div>
        </div>

        <div class="mui-card">
            <div class="mui-card-header">
                页眉
            </div>

            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    包含页眉页脚的卡片，页眉常用来显示面板标题，页脚用来显示额外信息或支持的操作（比如点赞、评论等）
                </div>
            </div>

            <div class="mui-card-footer">页脚</div>
        </div>
    </div>
</template>

<script>
    import lunbo from "../subcomponent/lunbotu.vue"
    export default {
        name: "goodsInfo",
        data(){
            return {
                id:this.$route.params.id,
                lunbos:[]
            }
        },
        components:{
          lunbo
        },
        methods:{
            getLunbo(){
                this.$axios
                    .get('/goods/lunbotu/'+this.id)
                    .then(res => {
                        res.data.data.forEach(e=>e.img=e.src)
                        this.lunbos=res.data.data
                    })
                    .catch(function (error) {
                        console.log(error);
                    });
            }
        },
        created() {
            this.getLunbo()
        }
    }
</script>

<style scoped lang="scss">
    .goods-container{
        background-color: #eeeeee;
        overflow: hidden;
    }
</style>