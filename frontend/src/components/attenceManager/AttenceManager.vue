<template>
  <div id="attencemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left">
          <el-button-group>
            <el-button
              type="success"
              size="default"
              icon="el-icon-folder-opened"
              @click="exportData"
              >导出数据</el-button
            >
            <el-button
              type="warning"
              icon="el-icon-refresh"
              size="default"
              @click="resetList"
              >重置</el-button
            >
            <el-button
              type="primary"
              icon="el-icon-edit-outline"
              size="default"
              @click="getSearchList"
              >考勤统计</el-button
            >
            <el-date-picker
              v-model="daterange"
              type="daterange"
              size="normal"
              value-format="yyyy-MM-dd"
              placeholder="选择日期"
            >
            </el-date-picker>
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
            v-loading="table_loading"
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="ID" label="ID"> </el-table-column>
            <el-table-column prop="name" label="姓名"> </el-table-column>
            <el-table-column prop="BM" label="部门"> </el-table-column>
            <el-table-column prop="date" label="打卡日期"> </el-table-column>
            <el-table-column prop="time" label="打卡时间"> </el-table-column>
            <el-table-column prop="nbr" label="打卡地点"> </el-table-column>
            <el-table-column prop="timetype" label="打卡情况">
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
      attence_data: [], // 列表数据
      search_status: false, // 搜索状态
      search_list: [{}], // 搜索结果列表
      btn_size: "medium", // 按钮大小
      attence_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
      daterange: [],
      attence_rule: [], // 考勤规则
      table_loading:true
    };
  },
  methods: {
    // 翻页
    getAttenceList() {
      if (!this.search_status) {
        let formdata = new FormData();
        formdata.append("currentPage", this.page_num);
        this.$axios({
          method: "post",
          url: "/nodeapi/faceapi/getkaoqin",
          data: formdata,
        }).then((res) => {
          this.table_loading=false;
          this.attence_data = res.data.data;
          this.attence_list_total = res.data.total;
        });
      } else {
        this.attence_list_total = this.search_list.length;
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
        this.table_loading=false;
      }
    },
    // 获取考勤规则
    getAttenceRule() {
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/BMlist",
      }).then((res) => {
        let rule_array = [];
        for (let i = 0; i < res.data.length; i++) {
          let rule_obj = {};
          rule_obj.department = res.data[i].BM;
          rule_obj.content = JSON.parse(res.data[i].content);
          rule_array.push(rule_obj);
        }
        this.attence_rule = rule_array;
      });
    },
    // 获取正常上班的请求数据列表
    async getGoToWorkTimeList() {
      let data_list = [];
      // 遍历所有规则中的正常时间
      for (let i = 0; i < this.attence_rule.length; i++) {
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        formdata.append("bm", this.attence_rule[i].department);
        for (let j = 0; j < this.attence_rule[i].content.length; j++) {
          formdata.append(
            "time1",
            this.attence_rule[i].content[j].determine_time[0]
          );
          formdata.append("time2", this.attence_rule[i].content[j].late_time);
          let post = () => {
            return new Promise((resolve) => {
              this.$axios({
                method: "post",
                url: "/nodeapi/faceapi/timekaoqin",
                data: formdata,
              }).then((res) => {
                for (let z = 0; z < res.data.length; z++) {
                  res.data[
                    z
                  ].timetype = `上班`;
                }
                resolve(res.data);
              });
            });
          };
          data_list.push(await post());
        }
      }
      return data_list;
    },
    // 获取迟到的请求数据列表
    async getLatetimeList() {
      let data_list = [];
      // 遍历所有规则中的正常时间
      for (let i = 0; i < this.attence_rule.length; i++) {
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        formdata.append("bm", this.attence_rule[i].department);
        for (let j = 0; j < this.attence_rule[i].content.length; j++) {
          formdata.append("time1", this.attence_rule[i].content[j].late_time);
          formdata.append(
            "time2",
            this.attence_rule[i].content[j].first_absenteeism_time
          );
          let post = () => {
            return new Promise((resolve) => {
              this.$axios({
                method: "post",
                url: "/nodeapi/faceapi/timekaoqin",
                data: formdata,
              }).then((res) => {
                for (let z = 0; z < res.data.length; z++) {
                  res.data[
                    z
                  ].timetype = `迟到`;
                }
                resolve(res.data);
              });
            });
          };
          data_list.push(await post());
        }
      }
      return data_list;
    },
    // 获取旷工时间的请求数据列表
    async getAbsenteeismtimeList() {
      let data_list = [];
      // 遍历所有规则中的正常时间
      for (let i = 0; i < this.attence_rule.length; i++) {
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        formdata.append("bm", this.attence_rule[i].department);
        for (let j = 0; j < this.attence_rule[i].content.length; j++) {
          formdata.append(
            "time1",
            this.attence_rule[i].content[j].first_absenteeism_time
          );
          formdata.append(
            "time2",
            this.attence_rule[i].content[j].second_absenteeism_time
          );
          let post = () => {
            return new Promise((resolve) => {
              this.$axios({
                method: "post",
                url: "/nodeapi/faceapi/timekaoqin",
                data: formdata,
              }).then((res) => {
                for (let z = 0; z < res.data.length; z++) {
                  res.data[
                    z
                  ].timetype = `旷工`;
                }
                resolve(res.data);
              });
            });
          };
          data_list.push(await post());
        }
      }
      return data_list;
    },
    // 获取早退的请求数据列表
    async getLeaveearlytimeList() {
      let data_list = [];
      // 遍历所有规则中的正常时间
      for (let i = 0; i < this.attence_rule.length; i++) {
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        formdata.append("bm", this.attence_rule[i].department);
        for (let j = 0; j < this.attence_rule[i].content.length; j++) {
          formdata.append(
            "time1",
            this.attence_rule[i].content[j].second_absenteeism_time
          );
          formdata.append(
            "time2",
            this.attence_rule[i].content[j].leave_early_time
          );
          let post = () => {
            return new Promise((resolve) => {
              this.$axios({
                method: "post",
                url: "/nodeapi/faceapi/timekaoqin",
                data: formdata,
              }).then((res) => {
                for (let z = 0; z < res.data.length; z++) {
                  res.data[
                    z
                  ].timetype = `早退`;
                }
                resolve(res.data);
              });
            });
          };
          data_list.push(await post());
        }
      }
      return data_list;
    },
    // 获取下班的请求数据列表
    async getTimeFromWorkList() {
      let data_list = [];
      // 遍历所有规则中的正常时间
      for (let i = 0; i < this.attence_rule.length; i++) {
        let formdata = new FormData();
        formdata.append("nowdate", this.daterange[0]);
        formdata.append("nextdate", this.daterange[1]);
        formdata.append("bm", this.attence_rule[i].department);
        for (let j = 0; j < this.attence_rule[i].content.length; j++) {
          formdata.append(
            "time1",
            this.attence_rule[i].content[j].leave_early_time
          );
          formdata.append(
            "time2",
            this.attence_rule[i].content[j].determine_time[1]
          );
          let post = () => {
            return new Promise((resolve) => {
              this.$axios({
                method: "post",
                url: "/nodeapi/faceapi/timekaoqin",
                data: formdata,
              }).then((res) => {
                for (let z = 0; z < res.data.length; z++) {
                  res.data[
                    z
                  ].timetype = `下班`;
                }
                resolve(res.data);
              });
            });
          };
          data_list.push(await post());
        }
      }
      return data_list;
    },
    // 获取搜索列表
    getSearchList() {
      if (!this.daterange.length == 0) {
        this.table_loading=true;
        this.search_status=true;
        const data_list = [];
        Promise.all([
          this.getGoToWorkTimeList(),
          this.getLatetimeList(),
          this.getAbsenteeismtimeList(),
          this.getLeaveearlytimeList(),
          this.getTimeFromWorkList(),
        ]).then((res) => {
          data_list.push(res);
          let res_list = [];
          // 获取promise类的请求结果，逐个拆解
          for (let first_array_item of data_list) {
            for (let second_array_item of first_array_item) {
              for (let item of second_array_item) {
                // 若结果集内容非空，则将结果放入到数据数组
                if (item.length != 0) {
                  for (let last_item of item) {
                    res_list.push(last_item);
                  }
                }
              }
            }
          }
          this.table_loading=false;
          this.page_num=1;
          this.search_list = res_list;
          this.getAttenceList();
        });
      } else {
        this.$message.error("请先选择日期范围");
      }
    },
    // 重置列表
    resetList(){
      this.search_status = false;
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
            title: "部门",
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
          {
            title: "打卡情况",
            key: "timetype",
          },
        ];
        export2Excel(columns, this.search_list);
      } else {
        this.$message.error("请先选择日期范围");
      }
    },
  },
  mounted() {
    this.getAttenceRule();
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
