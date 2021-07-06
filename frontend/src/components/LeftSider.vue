<template>
  <div>
    <el-menu
      ref="menu"
      class="el-menu-vertical-demo"
      background-color="#242f42"
      text-color="#FFFFFF"
      active-text-color="#EEA243"
      style="height: 100%"
      :unique-opened="true"
      :router="true"
      :default-active="$route.path"
    >
      <el-menu-item index="/mgr/home">
        <i class="el-icon-s-home"></i>
        <span>首页</span>
      </el-menu-item>

      <el-menu-item index="/mgr/accountmanager">
        <i class="el-icon-user-solid"></i>
        <span>账号管理</span>
      </el-menu-item>

      <el-menu-item index="/mgr/facemanager">
        <i class="el-icon-s-custom"></i>
        <span>人脸数据管理</span>
      </el-menu-item>

      <el-submenu index="2">
        <template slot="title">
          <i class="el-icon-postcard"></i>
          <span>考勤数据处理</span>
        </template>
        <el-menu-item index="" @click="openDatabaseConnectDrawer()">
          <i class="el-icon-setting"></i>
          <span> 数据库连接配置</span>
        </el-menu-item>
        <el-menu-item index="/mgr/model">
          <i class="el-icon-setting"></i>
          <span> 考勤模板管理</span>
        </el-menu-item>
        <el-menu-item index="/mgr/dataExport">
          <i class="el-icon-document"></i>
          <span>导出数据</span>
        </el-menu-item>
      </el-submenu>
      <el-menu-item index="" @click="loginOut()">
        <i class="el-icon-switch-button"></i>
        <span>退出登录</span>
      </el-menu-item>
    </el-menu>
    <el-drawer
      :visible.sync="database_drawer"
      direction="rtl"
      size="auto"
      :destroy-on-close="true"
      :show-close="true"
      :wrapperClosable="true"
    >
      <database-connect style="margin-right: 20px"></database-connect>
    </el-drawer>
  </div>
</template>

<script>
import DatabaseConnect from "@/components/views/DatabaseConnect";
export default {
  name: "liftsider",
  data() {
    return {
      router_path: "/mgr",
      database_drawer: false,
    };
  },
  components: {
    DatabaseConnect,
  },
  methods: {
    openDatabaseConnectDrawer() {
      this.database_drawer = true;
    },
    loginOut() {
      this.$store.dispatch("loginOut");
      this.$router.push("/login");
    },
  },
  // 处理浏览器刷新后导航选中问题
  watch: {
    $route() {
      let i = this.$route.path;
      localStorage.setItem("index", i); //刷新
      setTimeout(() => {
        //路由跳转
        this.$refs.menu.activeIndex = i;
      }, 100);
    },
  },
};
</script>

<style scoped>
.el-menu-item.is-active,
.el-menu-item:hover {
  background: rgb(29, 38, 53) !important;
  color: #eea243;
}

.el-menu span {
  font-size: 0.9rem;
}
.el-menu {
  border-right-width: 0;
  font-family: "PingFang SC";
  font-size: 0.9rem;
}
.el-menu li {
  font-size: 0.9rem;
}
.el-menu-item {
  min-width: 10px;
}
</style>

<style>
.el-submenu__title:hover {
  background: rgb(29, 38, 53) !important;
  color: #eea243;
}
</style>
