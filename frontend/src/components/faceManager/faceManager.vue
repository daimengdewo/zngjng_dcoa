<template>
  <div id="facemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
          
          <el-button-group>
            <el-popover placement="bottom-start" width="200" style="float:left" trigger="click">
              <div ref="qrcode"></div>
              <el-button
                type="success"
                size="default"
                slot="reference"
                icon="el-icon-circle-plus-outline"
                
                >新增人脸</el-button
              >
            </el-popover>
            
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
              placeholder="请输入任意员工姓名"
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
            stripe
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="" label="id" width="100"> </el-table-column>
            <el-table-column prop="" label="员工姓名" width="200">
            </el-table-column>

            <el-table-column prop="" label="人脸图片" width="200">
              <template slot-scope="scope"> </template>
            </el-table-column>
            <el-table-column align="right" width="400">
              <template slot="header" slot-scope="scope"> 操作</template>
              <template slot-scope="scope">
                <el-button
                  type="primary"
                  icon="el-icon-user"
                  :size="btn_size"
                  round
                  plain
                  @click=""
                  >重新上传人脸</el-button
                >
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  :size="btn_size"
                  round
                  plain
                  @click=""
                  >删除人脸</el-button
                >
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
            :total="face_list_total"
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
import QRCode from "qrcodejs2";

export default {
  name: "facemanager",
  data() {
    return {
      face_data: [{}], // 列表数据
      search: "", // 搜索框内容
      search_status: false, // 搜索状态控制
      search_list: [{}], // 搜索结果列表
      btn_size: "medium", // 按钮大小
      face_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
      request_url: "", // 请求地址
    };
  },
  methods: {
    getFacelist() {
      this.$axios({
        method: "post",
        url: this.request_url + "",
        data: {
          paging: 20,
          pagenbr: this.page_num,
        },
      }).then((res) => {});
    },
    test() {
      let reg = /http:\/\/([^\/]+)/i; // 提取域名的正则表达式
      let href = window.location.href.match(reg)[0]; // 获取域名
      let qrcode = new QRCode(this.$refs.qrcode, {
        width: 200,
        height: 200, // 高度
        text: href+"/faceadd", // 二维码内容
      });
    },
  },
  mounted() {
    this.test();
  },
  components: {},
};
</script>

<style scoped>
#facemanager,
.el-card {
  height: 100%;
  overflow: hidden;
}

.el-table {
  width: 100%;
}
</style>

<style>
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-thumb {
  border-radius: 5px;
  background-color: rgb(200, 200, 200);
}

#facemanager .el-table td,
#facemanager .el-table td span,
#facemanager .el-table th {
  text-align: center;
  font-size: 15px;
}

#facemanager .el-table th {
  background-color: #ecf5ff;
}

h1 {
  margin: 10px auto;
  text-align: center;
  font-size: 1.6rem;
}
</style>
