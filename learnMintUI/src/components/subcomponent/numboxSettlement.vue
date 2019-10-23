<template>
    <div class="mui-numbox" data-numbox-min='1' style="height: 25px;">
        <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
        <input id="test" class="mui-input-numbox" type="number" :value="dt"
         ref="cartNum" readonly @change="changeNmu()"/>
        <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
    </div>
</template>

<script>
    import mui from "../../lib/mui/js/mui.min.js"
    export default {
        name: "numbox",
        data(){
            return {

            }
        },
        mounted() {
            mui(".mui-numbox").numbox();
        },
        methods:{
            changeNmu(){
                this.$store.commit("updateCartNmu",{id:this._id,count:this.$refs.cartNum.value})
            }
        },
        watch:{
        },
        props:["dt","_id"]
    }
</script>

<style scoped lang="scss">
    .mui-numbox{

    }
</style>