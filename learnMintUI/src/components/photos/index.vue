<template>
    <div>
        <div id="slider" class="mui-slider">
            <div id="sliderSegmentedControl" class="mui-scroll-wrapper mui-slider-indicator mui-segmented-control mui-segmented-control-inverted">
                <div class="mui-scroll">
                    <a v-for="(cate) in cates" :key="cate.id" :class="['mui-control-item',cate.id=='000'?'mui-active':'']" @click="getPhotos(cate.id)">
                        {{cate.title}}
                    </a>
                </div>
            </div>

        </div>
        <ul>
            <li v-for="item in list" :key="item.id">
                <img v-lazy="item.img_url">
            </li>
        </ul>
    </div>
</template>

<script>
    import mui from "../../lib/mui/js/mui.js"

    export default {
        name: "index",
        data(){
            return {
                cates:[],
                list:[]
            }
        },
        mounted(){
            mui('.mui-scroll-wrapper').scroll({
                deceleration: 0.0005 //flick 减速系数，系数越大，滚动速度越慢，滚动距离越小，默认值0.0006
            });

        },
        created() {
            this.getCates()
            this.getPhotos("000")
        },
        methods:{
            getCates(){
                this.$axios.get("/getPhotoCates").then(r=>{
                    this.cates = r.data.msg
                    this.cates.unshift({id:"000",title:"全部"})
                })
            },
            getPhotos(cateId){
                this.$axios.get("/getPhotos/"+cateId).then(r=>{
                    this.list = r.data.msg
                })
            }
        }
    }
</script>

<style scoped lang="scss">
*{
    touch-action:pan-y;
}

img[lazy="loading"] {
    width: 40px;
    height: 300px;
    margin: auto;
}

</style>