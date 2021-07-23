<template>
  <div id="attencerule">
    <el-card shadow="always" :body-style="{ padding: '20px', height: '100%' }">
      <div slot="header">
        <h1>考勤规则</h1>
      </div>
      <!-- card body -->
      <el-row :gutter="20">
        <el-col :span="8" :offset="0">
          <h3 style="text-align: center; margin: 10px auto">第一步：添加时间段</h3>
          <el-form ref="form" :model="timeform" label-width="120px">
            <el-form-item label="时间段名称" prop="time_name" size="normal">
              <el-input
                v-model="timeform.time_name"
                placeholder="例如：上午上班"
              ></el-input>
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
                style="width:100%"
              >
              </el-time-picker>
            </el-form-item>
            <el-form-item label="迟到时间" prop="late_time" size="normal">
              <el-time-picker
                v-model="timeform.late_time"
                :picker-options="{'selectableRange': '00:00:00 - 23:59:59'}"
                format="HH:mm"
                value-format="HH:mm"
                placeholder="">
              </el-time-picker>
            </el-form-item>
            <el-form-item label="第一个旷工时间" prop="first_absenteeism_time" size="normal">
              <el-time-picker
                v-model="timeform.first_absenteeism_time"
                :picker-options="{'selectableRange': '00:00:00 - 23:59:59'}"
                format="HH:mm"
                value-format="HH:mm"
                placeholder="">
              </el-time-picker>
            </el-form-item>
            <el-form-item label="第二个旷工时间" prop="second_absenteeism_time" size="normal">
              <el-time-picker
                v-model="timeform.second_absenteeism_time"
                :picker-options="{'selectableRange': '00:00:00 - 23:59:59'}"
                format="HH:mm"
                value-format="HH:mm"
                placeholder="">
              </el-time-picker>
            </el-form-item>
            <el-form-item label="早退时间" prop="leave_early_time" size="normal">
              <el-time-picker
                v-model="timeform.leave_early_time"
                :picker-options="{'selectableRange': '00:00:00 - 23:59:59'}"
                format="HH:mm"
                value-format="HH:mm"
                placeholder="">
              </el-time-picker>
            </el-form-item>
            <el-form-item v-show="false" label="适用部门" prop="department" size="normal">
              <el-select
                v-model="timeform.department"
                placeholder="请选择部门"
                clearable
                filterable
                style="width:100%"
              >
                <el-option
                  v-for="(item, index) in department"
                  :key="index"
                  :label="item.label"
                  :value="item.value"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="8" :offset="0"></el-col>
        <el-col :span="8" :offset="0"></el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "attencerule",
  data() {
    return {
      timeform: {
        time_name: "",
        during_rush_hours: "",
        department: "",
        late_time:"",
        first_absenteeism_time:"",
        second_absenteeism_time:"",
        leave_early_time:""
      },
      department: [],
    };
  },
  methods: {},
  mounted() {},
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
  text-align: left;
  font-size: 2rem;
}
</style>
