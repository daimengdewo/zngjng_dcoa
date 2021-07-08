<template>
  <div id="attencemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
          <el-button-group>
            <el-button
              type="warning"
              size="default"
              icon="el-icon-refresh"
              @click=""
              >重置</el-button
            >
            <el-button
              type="primary"
              icon="el-icon-search"
              size="default"
              @click=""
              >搜索</el-button
            >
            <el-input
              v-model="search"
              placeholder="请输入任意账号"
              size="normal"
              clearable
              style="width: 200px"
            ></el-input>
          </el-button-group>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top: 5px">
        <el-col :span="1" :offset="0"></el-col>

        <el-col :span="22" :offset="0">
          <el-table
            :data="attence_data"
            stripe
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="" label="用户名"> </el-table-column>
            <el-table-column prop="" label="账号"> </el-table-column>

            <el-table-column prop="" label="密码">
              <template slot-scope="scope">
                <el-link
                  type="primary"
                  :underline="false"
                  @click="isNeedPassword(scope.row.username, 'getPassword')"
                >
                  <span>查看</span>
                  <i class="el-icon-view"></i>
                </el-link>
              </template>
            </el-table-column>

          </el-table>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
      <el-row
        :gutter="0"
        type="flex"
        justify="space-between"
        style="margin-top: 5px"
      >
        <!-- 分页插件 -->
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0">
          <el-pagination
            background
            layout="total,prev, pager, next,jumper"
            :page-size="20"
            :total="attence_list_total"
            @current-change=""
            :current-page.sync="page_num"
          >
          </el-pagination>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
    </el-card>


  </div>
</template>

<script>


export default {
  name: "attencemanager",
  data() {
    return {
      attence_data: [{}], // 列表数据
      search: "", // 搜索框内容
      search_status: false, // 搜索状态控制
      search_list: [{}], // 搜索结果列表
      btn_size: "medium", // 按钮大小
      attence_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
    };
  },
  methods: {
      getAttenceList(){
          let formdata=new FormData();
          formdata.append('currentPage',this.page_num);
          this.$axios({
              method:'post',
              url: "/nodeapi/faceapi/getkaoqin",
              data: formdata
          }).then(res=>{
              console.log(res.data);
          })
      }
  },
  mounted() {
    this.getAttenceList();
  },
};
</script>

<style scoped>
#attencemanager,
.el-card {
  height: 100%;
  overflow: hidden;
}

.el-table {
  width: 100%;
}
</style>

<style>

#attencemanager .el-table td,
#attencemanager .el-table td span,
#attencemanager .el-table th {
  text-align: center;
  font-size: 15px;
}

#attencemanager .el-table th {
  background-color: #ecf5ff;
}

h1 {
  margin: 10px auto;
  text-align: center;
  font-size: 1.6rem;
}
</style>
