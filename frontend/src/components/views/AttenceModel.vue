<template>
  <div id="attencemodel">
    <el-card :body-style="{ padding: '20px', 'line-height': '100%' }">
      <!-- card body -->

      <el-row type="flex" justify="space-around">
        <el-col :span="15" :offset="0">
          <el-button-group>
            <el-button
              type="warning"
              size="default"
              icon="el-icon-folder"
              @click=""
              >上传模板</el-button
            >

            <el-button
              type="primary"
              size="default"
              icon="el-icon-search"
              @click=""
              >搜索</el-button
            >
            <el-input
              placeholder="请输入模板名称搜索"
              size="normal"
              clearable
              style="width: 300px"
            ></el-input>
          </el-button-group>
        </el-col>
        <el-col :span="9" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around">
        <el-col :span="15" :offset="0">
          <el-table :data="model_data" :fit="true" stripe height="650">
            <el-table-column prop="num" label="序号" width="100">
            </el-table-column>
            <el-table-column prop="name" label="模板名称"> </el-table-column>
            <el-table-column prop="type" label="所属分类"> </el-table-column>
            <el-table-column prop="people" label="作者"> </el-table-column>
            <el-table-column label="模板样式">
              <template slot-scope="scope">
                <el-button type="text" size="default" icon="el-icon-view"
                  >预览</el-button
                >
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="danger" size="medium" icon="el-icon-delete"
                  >删除</el-button
                >
              </template>
            </el-table-column>
          </el-table>
        </el-col>
        <el-col
          :span="9"
          :offset="0"
          style="padding-left: 10px; margin-top: 5px"
        >
          <h2 style="margin: 0">预览效果:</h2>
          <!-- <table
            border="1"
            cellpadding="0"
            cellspacing="0"
            style="margin-top: 10px; font-size: 15px; text-align: center"
          >
            <tbody>
              <tr v-for="item in 9" :key="item">
                <td
                  v-for="j in item"
                  :key="j"
                  style="border: 1px black solid; padding: 5px"
                >
                  {{ j + "x" + item + "=" + j * item }}
                </td>
              </tr>
            </tbody>
          </table> -->
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around">
        <el-col :span="15" :offset="0">
          <el-pagination
            layout="total,prev, pager, next,jumper"
            background
            :total="50"
            :page-size="20"
          >
          </el-pagination>
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
      model_data: [{}],
      view_data: [{}],
      page_num:1 // 控制页码
    };
  },
  methods: {
    // 获取模板列表
    getlist(){
      this.$axios({
        method:'post',
        url: "/api/common/dispat",
        data: {
          action:'list',
          data:{
            paging:20,
            pagenbr:this.page_num
          }
        }
      }).then(res=>{
        console.log(res.data.data);
      })
    }
  },
  mounted () {
    this.getlist();
  },
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
  overflow-y: hidden;
  overflow-x: auto;
}
</style>
<style lang="less">
#attencemodel .el-table td,
#attencemodel .el-table td span,
#attencemodel .el-table th {
  text-align: center;
  font-size: 15px;
}

#attencemodel .el-table th {
  background-color: #ecf5ff;
}

#attencemodel table {
  overflow: auto;
  width: auto;
}
</style>

