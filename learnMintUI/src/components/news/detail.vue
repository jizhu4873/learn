<template>
    <div>
    新闻详情 {{id}}
    </div>
</template>

<script>
    export default {
        name: "detail",
        data(){
            return {
                id:this.$route.params.id
            }
        },
        mounted() {
        }
    }
</script>

<style scoped>

</style>