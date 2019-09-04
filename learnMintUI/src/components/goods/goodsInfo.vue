<template>
    <div class="goods-container">

        <div class="mui-card">
            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    这是一个最简单的卡片视图控件；卡片视图常用来显示完整独立的一段信息，比如一篇文章的预览图、作者信息、点赞数量等
                </div>
            </div>
        </div>

        <div class="mui-card">
            <div class="mui-card-header">
                页眉
            </div>
            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    包含页眉页脚的卡片，页眉常用来显示面板标题，页脚用来显示额外信息或支持的操作（比如点赞、评论等）
                </div>
            </div>
        </div>

        <div class="mui-card">
            <div class="mui-card-header">
                页眉
            </div>

            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    包含页眉页脚的卡片，页眉常用来显示面板标题，页脚用来显示额外信息或支持的操作（比如点赞、评论等）
                </div>
            </div>

            <div class="mui-card-footer">页脚</div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "goodsInfo"
    }
</script>

<style scoped lang="scss">
    .goods-container{
        background-color: #eeeeee;
        overflow: hidden;
    }
</style>