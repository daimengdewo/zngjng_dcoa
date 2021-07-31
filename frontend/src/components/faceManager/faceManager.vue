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
            :key="change_num"
            height="700"
            style="font-size: 0.9rem; text-align: center;width:1405px"
          >
            <el-table-column prop="ID" label="id" width="100">
            </el-table-column>
            <el-table-column prop="name" label="员工姓名" width="200">
            </el-table-column>
            <el-table-column prop="BM" label="部门" width="200">
            </el-table-column>
            <el-table-column label="人脸图片" width="280">
              <template slot-scope="scope">
                <img :src="getFaceUrl(scope.row.faceid)"  style="width: 180px;height:auto;"></img>
              </template>
            </el-table-column>
            <el-table-column label="请假状态" width="150">
              <template slot-scope="scope">
                <span>{{scope.row.QJ==0?"请假中":"未请假"}}</span>
              </template>
            </el-table-column>
            <el-table-column label="请假时间" width="165">
              <template slot-scope="scope">
                <span>{{scope.row.QJ==0?scope.row.QJdate1+scope.row.QJdate2:""}}</span>
              </template>
            </el-table-column>
            <el-table-column align="right" width="300">
              <template slot="header" slot-scope="scope"> 操作</template>
              <template slot-scope="scope">
                <el-button type="warning" :size="btn_size" icon="el-icon-edit-outline" v-show="scope.row.Set=='0'&&scope.row.QJ=='1'?true:false" round plain @click="openAskOff(scope.row.name,scope.row.ID)">请假</el-button>
                <el-button type="warning" :size="btn_size" icon="el-icon-edit-outline" v-show="scope.row.QJ=='0'?true:false" round plain @click="cancelAskOff(scope.row.name,scope.row.ID)">取消请假</el-button>
                
                <el-button type="danger" v-show="scope.row.Set=='0'?false:true" :size="btn_size" icon="el-icon-s-check" round plain @click="auditFaceSubmit(scope.row.ID,scope.row.name,scope.row.BM,scope.row.faceid)">审核</el-button>
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
    <el-dialog
      :title="ask_off_name+'请假'"
      :visible.sync="ask_off_status"
      width="30%"
      >
      <el-form :model="ask_off_form" ref="ask_off_form" :rules="rules" label-width="80px" :inline="false" size="normal">
        <el-form-item label="请假时间" prop="range_time">
          <el-date-picker v-model="ask_off_form.range_time" type="datetimerange" style="width:100%"
              range-separator="至"
              start-placeholder="开始"
              end-placeholder="结束" size="normal" format="yyyy-MM-dd HH:mm:ss" value-format="yyyy-MM-dd HH:mm:ss">
          </el-date-picker>
        </el-form-item> 
      </el-form>
      <span slot="footer">
        <el-button @click="ask_off_status=false">取消</el-button>
        <el-button type="primary" @click="submitAskOff">确定</el-button>
      </span>
    </el-dialog>
    
  </div>
</template>

<script>
import QRCode from "qrcodejs2";
import utils from "@/store/utils";

export default {
  name: "facemanager",
  data() {
    return {
      face_data: [{}], // 列表数据
      btn_size: "medium", // 按钮大小
      face_list_total: 0, // 数据量
      page_num: Number(this.$route.params.currentPage),
      change_num: 0,
      ask_off_status: false,
      ask_off_form: {
        range_time: "",
        id: "",
      },
      rules: {
        range_time: [
          {
            required: true,
            message: "请先选择时间",
            trigger: ["blur", "change"],
          },
        ],
      },
      ask_off_name: "",
    };
  },
  methods: {
    getFacelist() {
      this.face_data = [];
      let formdata = new FormData();
      formdata.append("currentPage", this.$route.params.currentPage);
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/getface",
        data: formdata,
      }).then((res) => {
        this.face_data = res.data.data;
        this.face_list_total = res.data.total;
      });
    },
    getFaceUrl(url) {
      return `https://${url}`;
    },
    auditFaceSubmit(ID, nm, BM, faceid) {
      this.$confirm(`确定审核ID为${ID}的人脸？`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          let formdata = new FormData();
          formdata.append("id", ID);
          formdata.append("nm", `${nm},${BM}`);
          formdata.append("set", "0");
          formdata.append("url", faceid);
          formdata.append("file", "");
          Promise.all([
            this.auditFace(formdata),
            this.auditDeviceFace(ID, nm, faceid),
          ]).then((res) => {
            if (res[0] && res[1] == 200) {
              this.$message.success(`ID为${ID}的人脸审核成功`);
              this.getFacelist();
            }
          });
        })
        .catch(() => {});
    },
    async auditFace(formdata) {
      const post = () => {
        return new Promise((resolve, reject) => {
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/upload",
            data: formdata,
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }).then((res) => {
            resolve(true);
          });
        });
      };
      return await post();
    },
    async auditDeviceFace(ID, nm, faceid) {
      const post = () => {
        return new Promise((resolve, reject) => {
          utils.urlToBase64(`/imageurl/${ID}.jpg`, (dataUrl) => {
            this.$axios({
              method: "post",
              url: "/api/userapi/newface",
              data: {
                id: ID,
                name: nm,
                face: dataUrl.split(",")[1],
              },
            }).then((res) => {
              resolve(res.data.code);
            });
          });
        });
      };
      return await post();
    },
    getQRCodeUrl() {
      let reg; // 提取域名的正则表达式
      if (window.location.href.match(/https/)) {
        reg = /https:\/\/([^\/]+)/i;
      } else {
        reg = /http:\/\/([^\/]+)/i;
      }
      let href = window.location.href.match(reg)[0]; // 获取域名
      let qrcode = new QRCode(this.$refs.qrcode, {
        width: 200,
        height: 200, // 高度
        text: `${href}/faceadd`, // 二维码内容
      });
    },
    delFace(id) {
      this.$confirm("确定删除该人脸？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          Promise.all([
            this.delFaceSubmit(id),
            this.delDeviceFaceSubmit(id),
          ]).then((res) => {
            if (res[0] == 0 && res[1] == 200) {
              this.$message.success(`删除ID为：${id}人脸成功`);
              this.getFacelist();
            } else {
              this.$message.error(`删除ID为：${id}人脸失败`);
              this.getFacelist();
            }
          });
        })
        .catch(() => {});
    },
    async delFaceSubmit(id) {
      const post = () => {
        return new Promise((resolve, reject) => {
          let formdata = new FormData();
          formdata.append("id", id);
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/delface",
            data: formdata,
          }).then((res) => {
            resolve(res.data.ret);
          });
        });
      };
      return await post();
    },
    async delDeviceFaceSubmit(id) {
      const post = () => {
        return new Promise((resolve, reject) => {
          this.$axios({
            method: "post",
            url: "/api/userapi/delface",
            data: {
              id: id,
            },
          }).then((res) => {
            resolve(res.data.code);
          });
        });
      };
      return await post();
    },
    openAskOff(name, id) {
      this.ask_off_status = true;
      this.ask_off_name = name;
      this.ask_off_form.id = id;
    },
    submitAskOff() {
      this.$refs["ask_off_form"].validate((valid) => {
        if (valid) {
          this.$axios({
            method: "post",
            url: "/api/userapi/qjset",
            data: {
              id: this.ask_off_form.id,
              qjdate1: this.ask_off_form.range_time[0],
              qjdate2: this.ask_off_form.range_time[1],
              qj: "0",
            },
          }).then((res) => {
            if(res.data.ret==0){
              this.$message.success(`${this.ask_off_name}请假成功,请假从${this.ask_off_form.range_time[0]} 至 ${this.ask_off_form.range_time[1]}`);
              this.ask_off_status=false;
              this.$refs['ask_off_form'].resetFields();
              this.getFacelist();
            }else{
              this.$message.error('请假失败');
            }
          });
        }
      });
    },
    cancelAskOff(name,id){
      this.$confirm(`确定取消${name}的请假吗？`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(()=>{
        this.$axios({
          method:'post',
          url: "/api/userapi/qjset",
          data: {
            id:id,
            qj:"1"
          }
        }).then(res=>{
          if(res.data.ret==0){
            this.$message.success(`取消${name}的请假成功`);
            this.getFacelist();
          }else{
            this.$message.error(`取消${name}的请假失败`);
          }
        })
      })
    }
  },
  mounted() {
    this.getQRCodeUrl();
    this.getFacelist();
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
  overflow: auto;
}
</style>

<style>
.el-table__body-wrapper {
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
