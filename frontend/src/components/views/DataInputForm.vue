<template>
  <div>
    <!-- 数据源表单 -->
    <el-form ref="data_input_form" :model="data_input_form" label-width="120px">
      <el-form-item label="选择数据源：" prop="data_from" size="normal">
        <el-radio-group v-model="data_input_form.data_from">
          <el-radio-button
            v-for="item in data_from_group"
            :key="item.key"
            :label="item.label"
          >
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      data_input_form: {
        data_from: "海康威视",
      },
      data_from_group: [
        {
          key: 0,
          label: "海康威视",
        },
        {
          key: 1,
          label: "中国",
        },
      ],
    };
  },
};
</script>

<style lang="less" scoped>
</style>