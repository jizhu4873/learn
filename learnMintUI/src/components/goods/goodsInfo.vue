<template>
    <div class="goods-container">
        <lunbo :lunbos="lunbos" :is-full="false"></lunbo>

        <div class="mui-card">
            <div class="mui-card-header">
                {{info.title}}
            </div>
            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    <p class="price">
                        市场价：<del>￥{{info.market_price}}</del>&nbsp;&nbsp;销售价：<span class="now-price">￥{{info.sell_price}}</span>
                    </p>
                    <p>购买数量： <numbox></numbox></p>
                    <p>
                        <mt-button type="primary" size="small">立刻购买</mt-button>
                        <mt-button type="danger" size="small">加入购物车</mt-button>
                    </p>
                </div>
            </div>
        </div>

        <div class="mui-card">
            <div class="mui-card-header">
                商品参数
            </div>

            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    <p>商品货号：{{info.goods_no}}</p>
                    <p>库存情况：{{info.stock_quantity}}</p>
                    <p>上架时间：{{info.add_time}}</p>
                </div>
            </div>

            <div class="mui-card-footer">
                <mt-button type="primary"  size="large" plain>图文介绍</mt-button>
                <mt-button type="danger" size="large" plain>商品评论</mt-button>
            </div>
        </div>
    </div>
</template>

<script>
    import lunbo from "../subcomponent/lunbotu.vue"
    import numbox from "../subcomponent/numbox.vue"
    export default {
        name: "goodsInfo",
        data(){
            return {
                id:this.$route.params.id,
                lunbos:[],
                info:{}
            }
        },
        components:{
          lunbo, numbox
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
            },
            getGoodsinfo(){
                this.$axios.get("/goods/info/"+this.id).then(
                    r=>{
                        this.info=r.data.msg[0];
                    }
                )
            }
        },
        created() {
            this.getLunbo();
            this.getGoodsinfo()
        }
    }
</script>

<style scoped lang="scss">
    .goods-container{
        background-color: #eeeeee;
        overflow: hidden;
        .mui-card-content-inner{
            .price{
                .now-price{
                    color: red;
                    font-weight: bold;
                }
            }
        }
        .mui-card-footer{
            display: block;
            button{
                margin: 15px 0;
            }
        }

    }
</style>