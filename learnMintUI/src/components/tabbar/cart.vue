<template>
    <div>
        <div class="cartbox">
           <div class="list">
               <div class="mui-card" v-for="(item,index) in list" :key="item.id">
                   <div class="mui-card-content">
                       <div class="mui-card-content-inner">
                           <mt-switch v-model="$store.getters.getSelectedState[item.id]"
                           @change="updateSelectedState(item.id)"
                           ></mt-switch>
                           <img :src="item.thumb_path" alt="">
                           <div class="info">
                               <h4>{{item.title}}</h4>
                               <p>
                                   <span class="price">{{item.sell_price}}</span>
                                   <numbox :dt="$store.getters.cntById[item.id]" :_id="item.id"></numbox>
                                   <a href="#" @click.prevent="removeCart(item.id,index)">删除</a>
                               </p>
                           </div>
                       </div>
                   </div>
               </div>
           </div>

            <div class="mui-card">
                <div class="mui-card-content">
                    <div class="mui-card-content-inner settle">
                        <div class="left">
                            <p>总计（不含运费）</p>
                            <p>
                                已勾选商品
                                <span class="red">0</span>
                                件，总价
                                <span class="red">￥ 0</span>
                            </p>
                        </div>
                        <mt-button type="danger">结算</mt-button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import numbox from "../subcomponent/numboxSettlement.vue"

    export default {
        name: "cart",
        components:{
            numbox
        },
        data(){
            return {
                list:[]
            }
        },
        created() {
            this.getList()
        },
        methods:{
            getList(){
                var idArr = []
                this.$store.state.cart.forEach(item=>idArr.push(item.id))
                if(idArr.length<1)
                    return
                this.$axios
                    //.get('/cart/'+idArr.join(","))
                    .get('/cart/_ids.json')
                    .then(res => {
                        this.list=res.data.msg

                        // 深度拷贝购物车数据（后台假数据与localstore不真实）
                        let newList = []
                        idArr.forEach(d=>{
                            var obj = JSON.parse(JSON.stringify(this.list[0]));
                            obj.id=d
                            newList.push(obj)
                        })
                        this.list = newList
                    })
                    .catch(function (error) {
                        alert(error);
                    });
            },
            removeCart(id,index){
                this.list.splice(index,1)
                this.$store.commit("removeCart",id)
            },
            updateSelectedState(id){
                this.$store.commit("updateSelectedState",id)
            }
        }
    }
</script>

<style scoped lang="scss">
    .cartbox{
        background-color: #eeeeee;
        overflow: hidden;
        .list{
            .mui-card-content-inner{
                display: flex;
                justify-items: center;
                justify-content: space-between;
                img{
                    width: 60px;
                    height: 60px;
                }
                .info{
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    .price{
                        color: red;
                        font-weight: bold;
                    }
                }
            }
        }
        .settle{
            display: flex;
            justify-content: space-between;
            align-content: center;
            .left{
                .red{
                    color: red;
                    font-weight: bold;
                    font-size: 16px;
                }
            }
        }
    }
</style>