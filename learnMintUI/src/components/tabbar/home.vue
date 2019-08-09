<template>
   <div>
       <mt-swipe :auto="1000">
           <mt-swipe-item v-for="item in lunbos" :key="item.img">
               <img :src="item.img">
           </mt-swipe-item>
       </mt-swipe>
   </div>
</template>

<script>
    import axios from "axios"

    export default {
        name: "home.vue",
        data(){
            return {lunbos:[]}
        },
        methods:{
            getLunbo(){
                axios
                    .get('https://www.easy-mock.com/mock/5d09930224add5128091e046/example/vue/lunbo')
                    .then(res => (this.lunbos=res.data.data))
                    .catch(function (error) {
                        console.log(error);
                    });
            }
        },
        created() {
            this.getLunbo();
        }
    }
</script>

<style lang="scss" scoped>
    .mint-swipe{
        height: 200px;
        .mint-swipe-item{
            &:nth-child(1){
                background-color: #94ff9d;
            }
            &:nth-child(2){
                background-color: #b1ffd4;
            }
            &:nth-child(3){
                background-color: #d7ff78;
            }
            img{
                width: 100%;
                height: 100%;
            }

        }
    }
</style>