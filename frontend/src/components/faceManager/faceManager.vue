<template>
  <div id="facemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
            <el-popover
              placement="bottom-start"
              width="200"
              style="float: left"
              trigger="click"
            >
              <div ref="qrcode"></div>
              <el-button
                type="success"
                size="default"
                slot="reference"
                icon="el-icon-circle-plus-outline"
                >新增人脸</el-button
              >
            </el-popover>    
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around" style="margin-top: 5px">
        <el-col :span="1" :offset="0"></el-col>

        <el-col :span="22" :offset="0">
          <el-table
            stripe
            :data="face_data"
            height="700"
            style="font-size: 0.9rem; text-align: center;width:790px;"
          >
            <el-table-column prop="ID" label="id" width="100">
            </el-table-column>
            <el-table-column prop="name" label="员工姓名" width="200">
            </el-table-column>

            <el-table-column label="人脸图片" width="280">
              <template slot-scope="scope">
                <img :src="getFaceUrl(scope.row.faceid)"  style="width: 180px;height:auto;"></img>
              </template>
            </el-table-column>
            <el-table-column align="right" width="200">
              <template slot="header" slot-scope="scope"> 操作</template>
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  :size="btn_size"
                  round
                  plain
                  @click="delFace(scope.row.ID)"
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
            @current-change="getFacelist"
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
      btn_size: "medium", // 按钮大小
      face_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
    };
  },
  methods: {
    getFacelist() {
      let formdata = new FormData();
      formdata.append("currentPage", this.page_num);
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/getface",
        data: formdata
      }).then(res => {
        this.face_data = res.data.data;
        this.face_list_total = res.data.total;
      });
    },
    getFaceUrl(url){
      return `https://${url}`;
    },
    getQRCodeUrl() {
      let reg;// 提取域名的正则表达式
      if(window.location.href.match(/https/)){
        reg = /https:\/\/([^\/]+)/i; 
      }else{
        reg = /http:\/\/([^\/]+)/i;
      }
      let href = window.location.href.match(reg)[0]; // 获取域名
      let qrcode = new QRCode(this.$refs.qrcode, {
        width: 200,
        height: 200, // 高度
        text: `${href}/faceadd"` // 二维码内容
      });
    },
    delFace(id) {
      this.$confirm("确定删除该人脸？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        let formdata = new FormData();
        formdata.append("id", id);
        this.$axios({
          method: "post",
          url: "/nodeapi/faceapi/delface",
          data: formdata
        }).then(res => {
          if (res.data.ret == 0) {
            this.$message.success(`删除ID为：${id}人脸成功`);
            this.getFacelist();
          }
        });
      }).catch(()=>{});
    }
  },
  mounted() {
    this.getQRCodeUrl();
    this.getFacelist();
  },
  components: {}
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
  overflow: auto;
}


</style>

<style>

.el-table__body-wrapper{
  overflow: auto;
}

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
