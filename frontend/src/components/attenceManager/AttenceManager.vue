<template>
  <div id="attencemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
          <el-button-group>
            <el-button type="success" size="default" icon="el-icon-folder-opened" @click="exportData"
            >导出数据</el-button
          >
            <el-button
              type="warning"
              size="default"
              icon="el-icon-refresh"
              @click="resetList"
              >重置</el-button
            >
            <el-button
              type="primary"
              icon="el-icon-search"
              size="default"
              @click="getSearchList"
              >查询</el-button
            >
            <el-date-picker
              v-model="daterange"
              type="daterange"
              size="normal"
              value-format="yyyy-MM-dd"
              placeholder="选择日期"
            >
            </el-date-picker>

            <el-input
              v-model="search"
              placeholder="请输入任意账号"
              size="normal"
              clearable
              style="width: 200px"
              v-show="false"
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
            <el-table-column prop="ID" label="ID"> </el-table-column>
            <el-table-column prop="name" label="姓名"> </el-table-column>
            <el-table-column prop="device" label="打卡设备"> </el-table-column>
            <el-table-column prop="date" label="打卡日期"> </el-table-column>
            <el-table-column prop="time" label="打卡时间"> </el-table-column>
            <el-table-column prop="nbr" label="打卡地点"> </el-table-column>
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
            @current-change="getAttenceList"
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
import { export2Excel } from "@/common/js/util";

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
      daterange: [],
    };
  },
  methods: {
    getAttenceList() {
      if (!this.search_status) {
        let formdata = new FormData();
        formdata.append("currentPage", this.page_num);
        this.$axios({
          method: "post",
          url: "/nodeapi/faceapi/getkaoqin",
          data: formdata,
        }).then((res) => {
          this.attence_data = res.data.data;
          this.attence_list_total = res.data.total;
        });
      } else {
        this.attence_data = [];
        let start_data_num = (this.page_num - 1) * 20; // 20条数据为一页，记录到开始数据序号
        let paging = 0;
        for (let i = start_data_num; i < this.attence_list_total; i++) {
          if (paging > 19) {
            return;
          } else {
            this.attence_data[i] = this.search_list[i]; // 重新赋值
          }
          paging++;
        }
      }
    },
    getSearchList() {
      if (!this.daterange.length == 0) {
        this.search_status = true;
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        this.$axios({
          method: "post",
          url: "/nodeapi/faceapi/datekaoqin",
          data: formdata,
        }).then((res) => {
          this.search_list = res.data;
          this.attence_list_total = res.data.length;
          this.page_num = 1;
          this.getAttenceList();
        });
      } else {
        this.$message.error("请先选择日期范围");
      }
    },
    resetList() {
      this.search_status = false;
      this.daterange = [];
      this.page_num = 1;
      this.getAttenceList();
    },
    exportData() {
      if (!this.daterange.length == 0) {
        let columns = [
          {
            title: "ID",
            key: "ID",
          },
          {
            title: "姓名",
            key: "name",
          },
          {
            title: "打卡设备",
            key: "device",
          },
          {
            title: "打卡日期",
            key: "date",
          },
          {
            title: "打卡时间",
            key: "time",
          },
          {
            title: "打卡地点",
            key: "nbr",
          },
        ];
        export2Excel(columns, this.search_list);
      } else {
        this.$message.error("请先选择日期范围");
      }
    },
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
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-thumb {
  border-radius: 5px;
  background-color: rgb(200, 200, 200);
}

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
