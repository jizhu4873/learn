<template>
    <div class="mui-numbox" data-numbox-min='1'>
        <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
        <input id="test" class="mui-input-numbox" type="number" value="5"
        @change="addCartNum" ref="cartNum"/>
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
            addCartNum(){
                this.$emit("getCount",this.$refs.cartNum.value)
            }
        },
        props:["maxCartNum"],
        watch:{
            "maxCartNum":function (newVal, oldVal) {
                mui(".mui-numbox").numbox().setOption("max",newVal)
            }
        }
    }
</script>

<style scoped lang="scss">
    .mui-numbox{

    }
</style>