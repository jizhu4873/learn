<template>
    <div>
        <mt-swipe :auto="1000">
            <mt-swipe-item v-for="item in lunbos" :key="item.id">
                <img :src="item.img" :class="{full:isFull}">
            </mt-swipe-item>
        </mt-swipe>
    </div>
</template>

<script>
    export default {
        name: "lunbotu",
        props:["lunbos","isFull"]
    }
</script>

<style scoped lang="scss">
    .full{
        width: 100%;
    }
    .mint-swipe{
        height: 200px;
        .mint-swipe-item{
            text-align: center;
            img{
                height: 100%;
            }
        }
    }
</style>