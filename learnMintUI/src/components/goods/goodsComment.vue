<template>
    <div class="comment-box">
        <comm :id="$route.params.id"></comm>
    </div>
</template>

<script>
    import comm from "../subcomponent/comment.vue"
    export default {
        name: "goodsComment",
        components:{
            comm
        }

    }
</script>

<style scoped>

</style>