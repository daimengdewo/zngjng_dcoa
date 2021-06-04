<template>
  <div id="mainwin">
    <el-container style="height: 100%">
      <el-header style="padding: 0">
        <!-- Header content -->
        <headerside></headerside>
      </el-header>
      <el-container class="main-container" style="height: 100%">
        <!-- Aside content -->
        <el-aside width="210px" style="height: 100%">
          <leftsider></leftsider>
        </el-aside>
        <el-main height="100%">
          <!-- Main content -->
          <router-view />
        </el-main>
      </el-container>
      <!-- <el-footer height="70px">-->
      <!-- Footer content -->
      <!-- <router-view name="FooterSide"></router-view>
      </el-footer>-->
    </el-container>
  </div>
</template>

<script>
import headerside from "@/components/HeaderSide";
import leftsider from "@/components/LeftSider";

export default {
  name: "mainwin",
  components: {
    headerside,
    leftsider,
  },
};
</script>

<style scoped>
#mainwin {
  height: 100%;
}

.el-main {
  background-color: #ddd;
  padding: 0px;
}

.el-aside {
  background-color: rgb(29, 38, 53) !important;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE 10+ */
}

.el-aside::-webkit-scrollbar {
  display: none; /* Chrome Safari */
}

.el-footer {
  background-color: #ddd;
}
</style>


