<template>
  <div id="dataExport">
    <el-card shadow="always" :body-style="{ padding: '20px' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around">
        <el-col :span="12" :offset="0">
          <el-steps
            :space="500"
            :active="0"
            :process-status="step_status"
            finish-status="success"
            align-center
          >
            <el-step icon="el-icon-upload2" title="导入数据源"></el-step>
            <el-step icon="el-icon-document-copy" title="选择模板"></el-step>
            <el-step icon="el-icon-download" title="导出数据"></el-step>
          </el-steps>
        </el-col>
      </el-row>
      <el-divider direction="horizontal"></el-divider>

      <el-row type="flex" justify="space-around">
        <el-col :span="12" :offset="0">
          <data-input-form></data-input-form>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import dataInputForm from "@/components/views/DataInputForm";

export default {
  name: "dataExport",
  data() {
    return {
      step_status: "process",
    };
  },
  methods: {
    test() {
      console.log(1);
    },
  },
  mounted() {
    // this.test();
  },
  components: {
    dataInputForm,
  },
};
</script>

<style lang="less" scoped>
#dataExport,
.el-card {
  height: 100%;
  overflow: hidden;
}
</style>