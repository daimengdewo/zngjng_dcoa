<template>
  <div>
    <el-row type="flex" justify="space-around">
      <el-col :span="7" :offset="0">
        <el-card shadow="hover" :body-style="{ padding: '58.5px 0' }">
          <div slot="header">
            <h2>时间</h2>
          </div>
          <div class="nowtime">
            <i class="el-icon-pie-chart"></i>
            <span>{{ nowtime }}</span>
          </div>
        </el-card>
      </el-col>

      <el-col :span="16" :offset="0">
        <el-card shadow="hover" :body-style="{ padding: '0 20px' }">
          <div slot="header">
            <h2>服务器状态</h2>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-around">
      <el-col :span="7" :offset="0">
        <el-card
          shadow="hover"
          :body-style="{
            padding: '0px',
            height: '480px',
            overflow: 'auto'
          }"
        >
          <div slot="header">
            <h2>日历</h2>
          </div>
          <el-calendar></el-calendar>
          <!-- card body -->
        </el-card>
      </el-col>
      <el-col :span="16" :offset="0">
        <el-card
          shadow="always"
          :body-style="{ padding: '20px', height: '440px', overflow: 'auto' }"
        >
          <div slot="header">
            <!-- card title -->
            <h2>操作日志</h2>
          </div>
          <!-- card body -->
          <div style="text-align: left">
            <el-timeline :reverse="reverse">
              <el-timeline-item
                v-for="(activity, index) in activities"
                :key="index"
                :timestamp="activity.time"
              >
                {{ activity.detail_msg }}
              </el-timeline-item>
            </el-timeline>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "home",
  data() {
    return {
      nowtime: "", //获取时间参数
      reverse: false, //时间排序
      timer: null,
      activities: [{}] // 输出日志数据
    };
  },
  methods: {
    //获取系统时间并输出到页面显示
    getTime() {
      let systime = new Date();
      let hour = systime.getHours();
      let minute = systime.getMinutes();
      let second = systime.getSeconds();
      hour = hour < 10 ? "0" + systime.getHours() : systime.getHours();
      minute = minute < 10 ? "0" + systime.getMinutes() : systime.getMinutes();
      second = second < 10 ? "0" + systime.getSeconds() : systime.getSeconds();
      this.nowtime = hour + ":" + minute + ":" + second;
    },

    //获取最新的5条系统日志
    getSystemLog() {
      let self = this;
      this.$axios
        .get("/api/getlog")
        .then(function(ret) {
          self.activities = ret.data.data;
        })
        .catch(function(error) {
          this.$message.error(error.response.data.msg);
        });
    },
    //定时执行函数
    currentTime() {
      let getTime = setInterval(this.getTime, 500); //0.5秒更新一次系统时间
      let getSystemLog = setInterval(this.getSystemLog, 1000); // 1秒刷新一次日志
      return { getTime, getSystemLog };
    }
  },
  mounted() {
    this.getTime(); //页面加载完成时，第一次获取系统时间
    this.getSystemLog(); //获取系统日志
    this.timer = {
      getTime: setInterval(() => {
        this.getTime();
      }, 500),
      getSystemLog: setInterval(() => {
        this.getSystemLog();
      }, 1000)
    };
  },
  beforeDestroy() {
    clearInterval(this.timer.getTime);
    clearInterval(this.timer.getSystemLog);
    this.timer = null;
  }
};
</script>

<style scoped>
.nowtime {
  font-size: 3rem;
}

.el-row {
  margin: 10px 0;
}

.el-card {
  text-align: center;
}

h1 {
  font-size: 2.5rem;
  margin: 0;
}

h2 {
  margin: 0;
}
</style>

<style>
.el-card__body {
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE 10+ */
}

.el-card__body::-webkit-scrollbar {
  display: none; /* Chrome Safari */
}

.el-timeline-item__wrapper,
.el-timeline-item__timestamp {
  font-size: 1.05rem;
}

.el-calendar-table .el-calendar-day {
  height: 50px;
  line-height: 35px;
}

.el-calendar-table .el-calendar-day:hover,
.el-backtop,
.el-calendar-table td.is-today {
  color: #fff;
  background-color: #163c69 !important;
}

.el-calendar__body {
  text-align: center;
}

.el-main {
  padding: 0;
}
</style>
