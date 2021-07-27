<template>
  <div id="attencerulemanager">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: left"> </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top: 5px">
        <el-col :span="1" :offset="0"></el-col>

        <el-col :span="22" :offset="0">
          <el-table
            :data="attence_rule_data"
            stripe
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="BM" label="适用部门" width="200">
            </el-table-column>
            <el-table-column label="考勤规则具体内容" width="1100">
              <template slot-scope="scope">
                <el-table
                  :data="getAttenceRule(scope.row.content)"
                  border
                  stripe
                >
                  <el-table-column
                    prop="time_name"
                    label="时间段名称"
                  ></el-table-column>
                  <el-table-column label="判定时间">
                    <template slot-scope="scope">
                      {{ scope.row.determine_time[0] }}-{{
                        scope.row.determine_time[1]
                      }}
                    </template>
                  </el-table-column>
                  <el-table-column label="上下班时间">
                    <template slot-scope="scope">
                      {{ scope.row.during_rush_hours[0] }}-{{
                        scope.row.during_rush_hours[1]
                      }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    prop="late_time"
                    label="迟到时间"
                  ></el-table-column>
                  <el-table-column
                    prop="first_absenteeism_time"
                    label="第一个旷工时间"
                  ></el-table-column>
                  <el-table-column
                    prop="second_absenteeism_time"
                    label="第二个旷工时间"
                  ></el-table-column>
                  <el-table-column
                    prop="leave_early_time"
                    label="早退时间"
                  ></el-table-column>
                </el-table>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="default"
                  icon="el-icon-delete"
                  @click="delAttenceRule(scope.row.BM)"
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
            :total="attence_rule_list_total"
            @current-change="getAttenceRuleList"
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
  name: "attencerulemanager",
  data() {
    return {
      attence_rule_data: [], // 列表数据
      attence_rule_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
    };
  },
  methods: {
    getAttenceRuleList() {
      let formdata = new FormData();
      formdata.append("currentPage", this.page_num);
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/BMlist",
        data: formdata,
      }).then((res) => {
        this.attence_rule_list_total = res.data.length;
        this.attence_rule_data = res.data;
      });
    },
    getAttenceRule(rulestr) {
      return JSON.parse(rulestr);
    },
    delAttenceRule(BM) {
      this.$confirm("确认是否删除此考勤规则", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          let formdata = new FormData();
          formdata.append("bm", BM);
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/delguize",
            data: formdata,
          }).then((res) => {
            this.$message.error("删除成功");
            this.getAttenceRuleList();
          });
        })
        .catch(() => {});
    },
  },
  mounted() {
    this.getAttenceRuleList();
  },
};
</script>

<style scoped>
#attencerulemanager,
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

#attencerulemanager .el-table td,
#attencerulemanager .el-table td span,
#attencerulemanager .el-table th {
  text-align: center;
  font-size: 15px;
}

#attencerulemanager .el-table th {
  background-color: #ecf5ff;
}

h1 {
  margin: 10px auto;
  text-align: center;
  font-size: 1.6rem;
}
</style>
