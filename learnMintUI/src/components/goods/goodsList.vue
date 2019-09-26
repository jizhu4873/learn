<template>
    <div>
        <div class="item-list">
            <div class="item" v-for="good in goodsList" :key="good.id" @click="info(good.id)">
                <img :src="good.img_url" alt="">
                <h4>{{good.title}}</h4>
                <div class="info">
                    <p class="price">
                        <span class="new">${{good.sell_price}}</span>
                        <span class="old">${{good.market_price}}</span>
                    </p>
                    <p class="promotion">
                        <span class="new">热卖中</span>
                        <span class="old">剩{{good.stock_quantity}}件</span>
                    </p>
                </div>
            </div>
        </div>
        <mt-button type="danger" size="large" @click="getMore">加载更多</mt-button>
    </div>
</template>

<script>
    export default {
        name: "goodList",
        data(){
            return {
                pageIndex:1,
                goodsList:[]
            }
        },
        methods:{
            getGoodsList(){
                this.$axios.get("/goodsList.json?pageIndex="+this.pageIndex).then(r=>{
                    if(r.data.status == "0"){
                        this.goodsList=this.goodsList.concat(r.data.msg);
                    }
                })
            },
            getMore(){
                this.pageIndex++;
                this.getGoodsList();
            },
            info(id){
                this.$router.push({name:"goodsinfo",params:{id}})
            }
        },
        created() {
            this.getGoodsList();
        }
    }
</script>

<style scoped lang="scss">
    .item-list{
        justify-content: space-between;
        display: flex;
        flex-wrap: wrap;
        padding: 0 7px;
        .item{
            padding: 2px;
            margin: 3px 0;
            width: 49%;
            border: 1px solid #cccccc;
            box-shadow:2px 3px 1px  #cccccc;
            display: flex;
            flex-direction: column ;
            justify-content: space-between;
            min-height: 296px;
            img{
                width: 100%;
            }
            h4{
                font-size: 14px;
            }
            .info{
                background-color: #eeeeee;
                p{
                    margin: 0;
                    padding: 5px;
                }
                .price{
                    .new{
                        font-weight: bold;
                        color: red;
                    }
                    .old{
                        text-decoration: line-through;
                        padding-left: 10px;
                    }
                }
                .promotion{
                    display: flex;
                    justify-content: space-between;
                }
            }
        }
    }

</style>