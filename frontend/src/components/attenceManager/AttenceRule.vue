<template>
  <div id="attencerule">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <div slot="header">
        <h1 style="text-align: left">考勤规则</h1>
      </div>
      <!-- card body -->
      <el-row :gutter="20" justify="space-around" type="flex">
        <el-col :span="6" :offset="0">
          <h3 style="text-align: center; margin: 10px auto">添加/修改时间段</h3>
          <el-form
            ref="timeform"
            :rules="rules"
            :model="timeform"
            label-width="120px"
          >
            <el-form-item label="时间段名称" prop="time_name" size="normal">
              <el-select
                v-model="timeform.time_name"
                clearable
                :disabled="!time_name_status"
              >
                <el-option value="上午"> </el-option>
                <el-option value="下午"> </el-option>
                <el-option value="晚上"> </el-option>
                <el-option value="全天"> </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="判定时间" prop="determine_time" size="normal">
              <el-time-picker
                v-model="timeform.determine_time"
                is-range
                editable
                range-separator="至"
                start-placeholder="开始时间"
                end-placeholder="结束时间"
                format="HH:mm"
                value-format="HH:mm"
                style="width: 100%"
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item
              label="上下班时间"
              prop="during_rush_hours"
              size="normal"
            >
              <el-time-picker
                v-model="timeform.during_rush_hours"
                is-range
                editable
                range-separator="至"
                start-placeholder="上班时间"
                end-placeholder="下班时间"
                format="HH:mm"
                value-format="HH:mm"
                style="width: 100%"
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item label="迟到时间" prop="late_time" size="normal">
              <el-time-picker
                v-model="timeform.late_time"
                :picker-options="{ selectableRange: '00:00:00 - 23:59:59' }"
                format="HH:mm"
                value-format="HH:mm"
                placeholder=""
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item
              label="第一个旷工时间"
              prop="first_absenteeism_time"
              size="normal"
            >
              <el-time-picker
                v-model="timeform.first_absenteeism_time"
                :picker-options="{ selectableRange: '00:00:00 - 23:59:59' }"
                format="HH:mm"
                value-format="HH:mm"
                placeholder=""
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item
              label="第二个旷工时间"
              prop="second_absenteeism_time"
              size="normal"
            >
              <el-time-picker
                v-model="timeform.second_absenteeism_time"
                :picker-options="{ selectableRange: '00:00:00 - 23:59:59' }"
                format="HH:mm"
                value-format="HH:mm"
                placeholder=""
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item
              label="早退时间"
              prop="leave_early_time"
              size="normal"
            >
              <el-time-picker
                v-model="timeform.leave_early_time"
                :picker-options="{ selectableRange: '00:00:00 - 23:59:59' }"
                format="HH:mm"
                value-format="HH:mm"
                placeholder=""
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item size="normal">
              <el-button type="primary" size="default" @click="submitTimeForm"
                >确认提交</el-button
              >
              <el-button size="default" @click="reset">重置</el-button>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="6" :offset="0">
          <h3 style="text-align: center; margin: 10px auto">确认考勤规则</h3>

          <div class="el-form-item is-required el-form-item--normal">
            <label class="el-form-item__label" style="width: 120px"
              >适用部门</label
            >
            <div class="el-form-item__content" style="margin-left: 120px">
              <el-input v-model="department" size="normal" clearable></el-input>
            </div>
          </div>

          <el-collapse
            :accordion="false"
            v-model="timelist_update_status"
            v-show="getTimeListStatus"
          >
            <el-collapse-item
              v-for="(item, index) in timelist"
              :key="index"
              :title="item.time_name"
              :name="index"
            >
              <!-- content -->
              <div>判定开始时间：{{ item.determine_time[0] }}</div>
              <div>判定结束时间：{{ item.determine_time[1] }}</div>
              <div>上班时间：{{ item.during_rush_hours[0] }}</div>
              <div>下班时间：{{ item.during_rush_hours[1] }}</div>
              <div>迟到时间：{{ item.late_time }}</div>
              <div>第一个旷工时间：{{ item.first_absenteeism_time }}</div>
              <div>第二个旷工时间：{{ item.second_absenteeism_time }}</div>
              <div>早退时间：{{ item.leave_early_time }}</div>
              <el-button
                type="text"
                size="default"
                @click="updateTimeList(index)"
                >修改</el-button
              >

              <el-button type="text" size="default" @click="delTimeItem(index)"
                >删除</el-button
              >
            </el-collapse-item>
          </el-collapse>
        </el-col>
        <el-col :span="6" :offset="0">
          <h3 style="text-align: center; margin: 10px auto">最后提交</h3>
          <el-card
            style="height: auto; background-color: #ecf5ff"
            shadow="always"
            :body-style="{
              padding: '20px',
              'line-height': '30px',
              color: '#909399',
            }"
          >
            <div slot="header">
              <h4 style="text-align: left; margin: 0; color: #909399">说明</h4>
            </div>
            <!-- card body -->
            <div>1.考勤规则一次提交只能设定一个部门</div>
            <div>2.<span style="color: #f56c6c"> * </span>表示该项为必填项</div>
            <div>3.考勤规则没有任何时间段时不能提交</div>
            <div>
              4.需要修改的时间段在点击修改后，在最左边的时间段表单内修改，最后点击确认提交
            </div>
            <div>
              5.重置即为清空时间段表单内的所有数据，对中间考勤规则的时间段没有影响
            </div>
          </el-card>
          <el-button
            type="primary"
            size="default"
            style="width: 100%; margin-top: 22px"
            @click="lastSubmit"
            >确认无误，提交</el-button
          >
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "attencerule",
  data() {
    let validateDuringrushhours = (rule, value, callback) => {
      if (value[0] <= this.timeform.determine_time[0]) {
        callback(new Error("上班时间不能早于判定的开始时间"));
      } else if (value[1] >= this.timeform.determine_time[1]) {
        callback(new Error("下班时间不能晚于判定的结束时间"));
      } else {
        callback();
      }
    };
    let validateLateTime = (rule, value, callback) => {
      if (value <= this.timeform.during_rush_hours[0]) {
        callback(new Error("迟到时间不能早于上班时间"));
      } else {
        callback();
      }
    };
    let validateFirstAbsenteeismTime = (rule, value, callback) => {
      if (value <= this.timeform.late_time) {
        callback(new Error("第一个旷工时间不能早于迟到时间"));
      } else {
        callback();
      }
    };
    let validateSecondAbsenteeismTime = (rule, value, callback) => {
      if (value <= this.timeform.first_absenteeism_time) {
        callback(new Error("第二个旷工时间不能早于第一个旷工时间"));
      } else {
        callback();
      }
    };
    let validateLeaveEarlyTime = (rule, value, callback) => {
      if (value <= this.timeform.second_absenteeism_time) {
        callback(new Error("早退不能早于第二个旷工时间"));
      } else if (value >= this.timeform.during_rush_hours[1]) {
        callback(new Error("早退不能晚于下班时间"));
      } else {
        callback();
      }
    };
    return {
      timeform: {
        time_name: "",
        determine_time: ["", ""],
        during_rush_hours: ["", ""],
        late_time: "",
        first_absenteeism_time: "",
        second_absenteeism_time: "",
        leave_early_time: "",
      },
      rules: {
        time_name: [
          { required: true, message: "请输入时间段名称", trigger: "blur" },
        ],
        determine_time: [
          {
            required: true,
            message: "请选择判定时间",
            trigger: "blur",
          },
        ],
        during_rush_hours: [
          { required: true, message: "请选择上下班时间", trigger: "blur" },
          { validator: validateDuringrushhours, trigger: ["blur", "change"] },
        ],
        late_time: [
          { required: true, message: "请选择迟到时间", trigger: "blur" },
          { validator: validateLateTime, trigger: ["blur", "change"] },
        ],
        first_absenteeism_time: [
          { required: true, message: "请选择第一个旷工时间", trigger: "blur" },
          {
            validator: validateFirstAbsenteeismTime,
            trigger: ["blur", "change"],
          },
        ],
        second_absenteeism_time: [
          { required: true, message: "请选择第二个旷工时间", trigger: "blur" },
          {
            validator: validateSecondAbsenteeismTime,
            trigger: ["blur", "change"],
          },
        ],
        leave_early_time: [
          { required: true, message: "请选择早退时间", trigger: "blur" },
          { validator: validateLeaveEarlyTime, trigger: ["blur", "change"] },
        ],
      },
      department: "",
      timelist: [],
      timelist_update_status: [],
      timelist_index: -1,
      time_name_status: true,
    };
  },
  methods: {
    // 提交表单放入考勤规则list
    submitTimeForm() {
      this.$refs["timeform"].validate((valid) => {
        if (valid) {
          this.timelist_index = -1;
          if (this.addTimeList()) {
            this.$refs["timeform"].resetFields();
          }
        } else {
          return false;
        }
      });
    },
    reset() {
      this.timelist_index = -1;
      this.time_name_status = true;
      this.$refs["timeform"].resetFields();
    },
    // 新增时间段
    addTimeList() {
      let { ...timeItem } = this.timeform;
      let error_msg = false;
      if (this.timelist_index == -1) {
        for (let item of this.timelist) {
          if (item.time_name == timeItem.time_name) {
            this.$message.error("不能添加相同的时间段");
            error_msg = true;
            return;
          } else {
            continue;
          }
        }
        if (!error_msg) {
          this.timelist.push(timeItem);
          this.$message.success("添加时间段成功");
          return true;
        } else {
          return false;
        }
      } else {
        this.timelist.splice(this.timelist_index, 1, timeItem);
        this.$message.success("修改时间段成功");
        this.time_name_status = true;
        return true;
      }
    },
    // 修改时间段
    updateTimeList(index) {
      let { ...timeItem } = this.timelist[index];
      this.timeform = timeItem;
      this.timelist_index = index;
      this.time_name_status = false;
    },
    // 删除时间段
    delTimeItem(index) {
      this.timelist.splice(index, 1);
      this.timelist_update_status = [];
    },
    // 最终提交
    lastSubmit() {
      if (this.department.length == 0) {
        this.$message.error("提交失败，部门不能为空");
      } else if (this.timelist.length == 0) {
        this.$message.error("提交失败，时间段不能为空");
      } else {
        let formdata = new FormData();
        formdata.append("bm", this.department);
        formdata.append("cont", JSON.stringify(this.timelist));
        this.$axios({
          method: "post",
          url: "/nodeapi/faceapi/guize",
          data: formdata,
        }).then((res) => {
          if (res.data.ret == 0) {
            this.$message.success("提交成功");
            this.department = "";
            this.timelist = [];
          }
        });
      }
    },
  },
  computed: {
    // 获取考勤规则list的状态，当列表为空时不显示
    getTimeListStatus() {
      let result = this.timelist.length == 0 ? true : false;
      return !result;
    },
  },
};
</script>

<style scoped>
#attencerule,
.el-card {
  height: 100%;
  overflow: hidden;
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

h1 {
  margin: 10px auto;
  font-size: 2rem;
}
</style>
