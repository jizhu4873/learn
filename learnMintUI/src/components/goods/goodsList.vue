<template>
    <div class="item-list">
        <div class="item">
            <img src="http://fuss10.elemecdn.com/b/18/0678e57cb1b226c04888e7f244c20jpeg.jpeg" alt="">
            <h4>小米（Mi）小米Note 16G双网通版</h4>
            <div class="info">
                <p class="price">
                    <span class="new">899</span>
                    <span class="old">999</span>
                </p>
                <p class="promotion">
                    <span class="new">热卖中</span>
                    <span class="old">剩60件</span>
                </p>

            </div>
        </div>
        <div class="item">
            <img src="http://fuss10.elemecdn.com/b/18/0678e57cb1b226c04888e7f244c20jpeg.jpeg" alt="">
            <h4>小米（Mi）小米Note 16G双网通版 热卖中 赶紧来买 还等什么</h4>
            <div class="info">
                <p class="price">
                    <span class="new">$899</span>
                    <span class="old">999</span>
                </p>
                <p class="promotion">
                    <span class="new">热卖中</span>
                    <span class="old">剩60件</span>
                </p>

            </div>
        </div>
        <div class="item">
            <img src="http://fuss10.elemecdn.com/b/18/0678e57cb1b226c04888e7f244c20jpeg.jpeg" alt="">
            <h4 class="item-title">小米（Mi）Note 16G双网通版</h4>
            <div class="info">
                <p class="price">
                    <span class="new">899</span>
                    <span class="old">999</span>
                </p>
                <p class="promotion">
                    <span class="new">热卖</span>
                    <span class="old">剩60件</span>
                </p>

            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: "goodsList"
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