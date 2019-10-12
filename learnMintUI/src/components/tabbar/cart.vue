<template>
    <div>
        <div class="cartbox">
           <div class="list">
               <div class="mui-card" v-for="item in list" :key="item.id">
                   <div class="mui-card-content">
                       <div class="mui-card-content-inner">
                           <mt-switch ></mt-switch>
                           <img :src="item.thumb_path" alt="">
                           <div class="info">
                               <h4>{{item.title}}</h4>
                               <p>
                                   <span class="price">{{item.sell_price}}</span>
                                   <numbox></numbox>
                                   <a href="#">删除</a>
                               </p>
                           </div>
                       </div>
                   </div>
               </div>
           </div>

            <div class="mui-card">
                <div class="mui-card-content">
                    <div class="mui-card-content-inner">
                        这是一个最简单的卡片视图控件；卡片视图常用来显示完整独立的一段信息，比如一篇文章的预览图、作者信息、点赞数量等
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
                    })
                    .catch(function (error) {
                        alert(error);
                    });
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
    }
</style>