<template>
  <div id="attencelocationmanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
          <el-button
            type="success"
            size="default"
            icon="el-icon-circle-plus-outline"
            @click="openLocationDialog"
            >新增地址</el-button
          >
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around" style="margin-top: 5px">
        <el-col :span="1" :offset="0"></el-col>

        <el-col :span="22" :offset="0">
          <el-table
            :data="location_list"
            stripe
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="BM" label="部门"> </el-table-column>
            <el-table-column prop="LngLat" label="经纬度"> </el-table-column>
            <el-table-column prop="address" label="地址"> </el-table-column>

            <el-table-column align="right">
              <template slot="header" slot-scope="scope"> 操作</template>
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  :size="btn_size"
                  round
                  plain
                  @click="delLocation(scope.row.BM)"
                  >删除</el-button
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
            :total="location_list_total"
            @current-change="turnPage"
            :current-page.sync="page_num"
          >
          </el-pagination>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
    </el-card>
    <el-dialog
      title="新增地址"
      :visible.sync="add_location_dialog_status"
      width="40%"
      @opened="setMap"
    >
      <div
        id="map"
        style="width: 100%; height: 300px; margin-bottom: 10px"
      ></div>
      <el-form
        :rules="rules"
        :model="loaction_form"
        ref="loaction_form"
        label-width="100px"
        :inline="false"
        size="normal"
      >
        <el-form-item label="地址搜索" size="normal">
          <el-select
            v-model="loaction_form.lnglat"
            placeholder="请搜索"
            :remote-method="searchLocation"
            @change="setLngLat"
            remote
            filterable
            style="width: 100%"
          >
            <el-option
              v-for="(item, index) in options"
              :key="index"
              :label="item.district + item.name"
              :value="item.location"
            >
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="经度，纬度" prop="lnglat" size="normal">
          <el-input
            v-model="loaction_form.lnglat"
            :disabled="true"
            size="normal"
          ></el-input>
        </el-form-item>
        <el-form-item label="显示地址" prop="address" size="normal">
          <el-input
            v-model="loaction_form.address"
            :disabled="true"
            size="normal"
          ></el-input>
        </el-form-item>
        <el-form-item label="部门" prop="bm" size="normal">
          <el-select
            v-model="loaction_form.bm"
            placeholder=""
            clearable
            filterable
          >
            <el-option
              v-for="(item, index) in department_list"
              :key="index"
              :label="item.BM"
              :value="item.BM"
            >
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button @click="add_location_dialog_status = false">取消</el-button>
        <el-button type="primary" @click="submit">提交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "attencelocationmanager",
  data() {
    return {
      location_list: [], // 显示用列表
      location_data: [], // 列表数据
      btn_size: "medium", // 按钮大小
      location_list_total: 0, //
      page_num: 1,
      add_location_dialog_status: false,
      loaction_form: {
        lnglat: "", // 经纬度
        address: "", // 地址
        bm: "", // 部门
      },
      rules: {
        lnglat: [
          {
            required: true,
            message: "请先搜索地址",
            trigger: ["blur", "change"],
          },
        ],
        address: [
          {
            required: true,
            message: "请先搜索地址",
            trigger: ["blur", "change"],
          },
        ],
        bm: [
          {
            required: true,
            message: "请选择部门",
            trigger: ["blur", "change"],
          },
        ],
      },
      department_list: [],
      options: [],
      map: "",
      marker: [],
    };
  },
  methods: {
    // 打开新增地址对话框
    openLocationDialog() {
      this.add_location_dialog_status = true;
      this.getDepartmentList();
    },
    // 获取部门列表
    getDepartmentList() {
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/BMlist",
      }).then((res) => {
        this.department_list = res.data;
      });
    },
    // 设置地图
    setMap() {
      let self = this;
      let map = new AMap.Map("map", {
        zoom: 17, //设置地图显示的缩放级别
        mapStyle: "amap://styles/normal", //设置地图的显示样式
        viewMode: "2D", //设置地图模式
        lang: "zh_cn", //设置地图语言类型
        resizeEnable: true,
      });
      this.map = map;
      return map;
    },
    // 查询地址
    searchLocation(query) {
      this.$axios({
        method: "get",
        url: "/amap/v3/assistant/inputtips",
        params: {
          key: "f8eaf56c6169d7ae683b0e84a2231ea4",
          keywords: query,
        },
      }).then((res) => {
        this.options = res.data.tips;
      });
    },
    // 设置经纬度
    setLngLat() {
      this.map.setCenter([
        this.loaction_form.lnglat.split(",")[0],
        this.loaction_form.lnglat.split(",")[1],
      ]);
      this.setAddress();
    },
    //设置地址
    setAddress() {
      this.$axios({
        method: "get",
        url: "/amap/v3/geocode/regeo",
        params: {
          key: "f8eaf56c6169d7ae683b0e84a2231ea4",
          location: this.loaction_form.lnglat,
        },
      }).then((res) => {
        this.loaction_form.address = res.data.regeocode.formatted_address;
      });
    },
    // 新增提交表单
    submit() {
      this.$refs["loaction_form"].validate((vaild) => {
        if (vaild) {
          let formdata = new FormData();
          formdata.append("lnglat", this.loaction_form.lnglat);
          formdata.append("bm", this.loaction_form.bm);
          formdata.append("address", this.loaction_form.address);
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/savejw",
            data: formdata,
          }).then((res) => {
            if (res.data) {
              this.$message.success("添加地址成功");
              this.getLocationList();
            }
          });
        }
      });
    },
    // 获取地址列表
    getLocationList() {
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/getalljw",
      }).then((res) => {
        this.location_data = res.data.data;
        this.location_list_total = res.data.total;
        this.turnPage();
      });
    },
    // 翻页
    turnPage() {
      this.location_list = [];
      let start_data_num = (this.page_num - 1) * 20; // 20条数据为一页，记录到开始数据序号
      let paging = 0;
      for (let i = start_data_num; i < this.location_list_total; i++) {
        if (paging > 19) {
          return;
        } else {
          this.location_list[i] = this.location_data[i]; // 重新赋值
        }
        paging++;
      }
    },
    // 删除地址
    delLocation(bm) {
      this.$confirm("确定删除该地址？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          let formdata = new FormData();
          formdata.append("bm", bm);
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/deljw",
            data: formdata,
          }).then((res) => {
            if (res.data == 1) {
              this.$message.success(`删除${bm}的地址成功`);
              this.getLocationList();
            }
          });
        })
        .catch(() => {});
    },
  },
  mounted() {
    this.getLocationList();
  },
  components: {},
};
</script>

<style scoped>
#attencelocationmanager,
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

#attencelocationmanager .el-table td,
#attencelocationmanager .el-table td span,
#attencelocationmanager .el-table th {
  text-align: center;
  font-size: 15px;
}

#attencelocationmanager .el-table th {
  background-color: #ecf5ff;
}

h1 {
  margin: 10px auto;
  text-align: center;
  font-size: 1.6rem;
}
</style>
