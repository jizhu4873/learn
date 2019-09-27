<template>
    <div class="goods-container">
        <transition
        @before-enter="beforEnter"
        @enter="enter"
        @after-enter="afterEnter"
        >
            <div class="ball" v-show="showBall" ref="ball"></div>
        </transition>
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
                    <p>购买数量： <numbox @getCount="getAddedCartNum" :maxCartNum="info.stock_quantity"></numbox></p>
                    <p>
                        <mt-button type="primary" size="small" >立刻购买</mt-button>
                        <mt-button type="danger" size="small" @click="addCart()">加入购物车</mt-button>
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
                <mt-button type="primary"  size="large" plain @click="goDesc">图文介绍</mt-button>
                <mt-button type="danger" size="large" plain @click="goComm">商品评论</mt-button>
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
                info:{},
                showBall:false,
                cartNum:1
            }
        },
        components:{
          lunbo, numbox
        },
        methods:{
            getLunbo(){
                this.$axios
                    //.get('/goods/lunbotu/'+this.id)
                    .get('/goods/lunbotu/_id.json')
                    .then(res => {
                        res.data.msg.forEach(e=>e.img=e.src)
                        this.lunbos=res.data.msg
                    })
                    .catch(function (error) {
                        console.log(error);
                    });
            },
            getGoodsinfo(){
                //this.$axios.get("/goods/info/"+this.id).then(
                this.$axios.get("/goods/info/_id.json").then(
                    r=>{
                        this.info=r.data.msg[0];
                    }
                )
            },
            goDesc(){
                this.$router.push({name:"goodsDesc",params:{id:this.id}})
            },
            goComm(){
                this.$router.push({name:"goodsComment",params:{id:this.id}})
            },
            addCart(){
                this.showBall=!this.showBall;
            },
            beforEnter(e){
                e.style.transform="translate(0,0)"
            },
            enter(e,done){
                e.offsetWidth
                //小球初始位置
                var ballPos = this.$refs.ball.getBoundingClientRect();
                //购物车徽标的位置
                var badgePos = document.getElementById("badge").getBoundingClientRect();
                var leftDist = badgePos.left - ballPos.left
                var topDist = badgePos.top-ballPos.top
                e.style.transform=`translate(${leftDist}px,${topDist}231px)`
                e.style.transition="all 1s cubic-bezier(.4,-0.3,.2,-0.68)"
                done()
            },
            afterEnter(e){
                this.showBall = !this.showBall
            },
            getAddedCartNum(cnt){
                this.cartNum=cnt;
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
        .ball{
            background-color: red;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            z-index: 99;
            position: absolute;
            left: 153px;
            top: 365px;
        }
        background-color: #eee;
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