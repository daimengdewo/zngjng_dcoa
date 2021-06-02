<template>
  <div id="attencemodel">
    <el-card :body-style="{ padding: '20px', 'line-height': '100%' }">
      <!-- card body -->

      <el-row type="flex" justify="space-around">
        <el-col :span="14" :offset="0">
          <el-button-group>
            <el-button type="warning" size="default" @click=""
              >上传模板</el-button
            >

            <el-button type="primary" size="default" @click="">搜索</el-button>
            <el-input
              placeholder="请输入模板名称搜索"
              size="normal"
              clearable
              style="width:300px"
            ></el-input>
          </el-button-group>
        </el-col>
        <el-col :span="9" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around">
        <el-col :span="14" :offset="0">
          <el-table :data="model_data" :fit="false" stripe max-height="600px">
            <el-table-column prop="num" label="序号" width="100">
            </el-table-column>
            <el-table-column prop="name" label="模板名称" width="300">
            </el-table-column>
            <el-table-column prop="people" label="创建者" width="150">
            </el-table-column>
            <el-table-column label="模板样式" width="100">
              <template slot-scope="scope">
                <el-button type="text" size="default" @click="">查看</el-button>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button type="danger" size="medium" @click=""
                  >删除</el-button
                >
              </template>
            </el-table-column>
          </el-table>
        </el-col>
        <el-col :span="9" :offset="0"></el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      model_data: [{}]
    };
  },
  methods: {}
};
</script>

<style scoped>


.el-row {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
}

.el-button-group {
  width: 100%;
}
#attencemodel,
.el-card {
  height: 100%;
  overflow: hidden;
}
</style>
<style>
#attencemodel .el-table td,
#attencemodel .el-table td span,
#attencemodel .el-table th {
  text-align: center;
  font-size: 15px;
}


#attencemodel .el-table th {
  background-color: #ecf5ff;
}
</style>
