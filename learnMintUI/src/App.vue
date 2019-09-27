<template>
  <div class="my-container">
    <mt-header fixed title="mint项目学习"></mt-header>
    <transition name="fade">
      <router-view></router-view>
    </transition>
    <!--底部-->
    <nav class="mui-bar mui-bar-tab">
      <router-link class="mui-tab-item-x" to="/home">
        <span class="mui-icon mui-icon-home"></span>
        <span class="mui-tab-label">首页</span>
      </router-link>
      <router-link class="mui-tab-item-x" to="/member">
        <span class="mui-icon mui-icon-contact"></span>
        <span class="mui-tab-label">会员</span>
      </router-link>
      <router-link class="mui-tab-item-x" to="/cart">
        <span class="mui-icon mui-icon-extra mui-icon-extra-cart"><span class="mui-badge" id="badge">0</span></span>
        <span class="mui-tab-label">购物车</span>
      </router-link>
      <router-link class="mui-tab-item-x" to="/search">
        <span class="mui-icon mui-icon-search"></span>
        <span class="mui-tab-label">搜索</span>
      </router-link>
    </nav>
    <!--底部-->
  </div>
</template>

<script>

</script>


<style lang="scss" scoped>
  .mint-header{
    z-index: 99;
  }
.my-container{
  padding-top: 40px;
  overflow-x: hidden;
  padding-bottom: 51px;
}
.fade-enter-active, .fade-leave-active {
  transition: all .5s ease;
}
.fade-enter {
  opacity: 0;
  transform:translateX(100%);
}
.fade-leave-to  {
  opacity: 0;
  transform:translateX(-100%);
  position: absolute;
}

.mui-bar-tab .mui-tab-item-x.mui-active{
  color: #007aff;
}


.mui-bar-tab .mui-tab-item-x {
  display: table-cell;
  overflow: hidden;
  width: 1%;
  height: 50px;
  text-align: center;
  vertical-align: middle;
  white-space: nowrap;
  text-overflow: ellipsis;
  color: #929292;
}

.mui-bar-tab .mui-tab-item-x .mui-icon {
  top: 3px;
  width: 24px;
  height: 24px;
  padding-top: 0;
  padding-bottom: 0;
}
.mui-bar-tab .mui-tab-item-x .mui-icon[data-v-7ba5bd90] {
  top: 3px;
  width: 24px;
  height: 24px;
  padding-top: 0;
  padding-bottom: 0;
}
.mui-bar-tab .mui-tab-item-x {
  display: table-cell;
  overflow: hidden;
  width: 1%;
  height: 50px;
  text-align: center;
  vertical-align: middle;
  white-space: nowrap;
  text-overflow: ellipsis;
  color: #929292;
}
.mui-bar-tab .mui-tab-item-x .mui-icon~.mui-tab-label {
  font-size: 11px;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
