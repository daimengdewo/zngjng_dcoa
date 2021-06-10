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
              @click="getSearchList"
              >搜索</el-button
            >
            <el-input
              placeholder="请输入模板名称搜索"
              size="normal"
              clearable
              v-model="search_model_name"
              style="width: 300px"
            ></el-input>
          </el-button-group>
        </el-col>
        <el-col :span="9" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around">
        <el-col :span="15" :offset="0">
          <el-table :data="model_data" :fit="true" stripe height="650">
            <el-table-column label="序号" width="100">
              <template slot-scope="scope">
                {{ scope.$index + 1 }}
              </template>
            </el-table-column>
            <el-table-column prop="mouldname" label="模板名称">
            </el-table-column>
            <el-table-column prop="type" label="所属分类"> </el-table-column>
            <el-table-column prop="username_id" label="作者"> </el-table-column>
            <el-table-column label="创建时间" width="108">
              <template slot-scope="scope">
                {{ changeTime(scope.row.create_date) }}
              </template>
            </el-table-column>
            <el-table-column label="模板样式">
              <template slot-scope="scope">
                <el-button type="text" size="default" icon="el-icon-view"
                  >预览</el-button
                >
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button
                  type="danger"
                  size="medium"
                  icon="el-icon-delete"
                  @click="delModel(scope.row.mouldname)"
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
            border="1px #ddd solid"
            cellpadding="0"
            cellspacing="0"
            style="margin-top: 10px; font-size: 15px; text-align: center"
          >
            <tbody>
              <tr v-for="item in view_data" :key="item">
                <td
                  v-for="(cell, index) in item"
                  :key="index"
                  style="border: 1px #ddd solid; padding: 5px"
                  :rowspan="cell.rowspan"
                >
                  {{ cell.value }}
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
            :total="model_data_total"
            :page-size="20"
            @current-change="getlist"
            :current-page.sync="page_num"
          >
          </el-pagination>
        </el-col>
        <el-col :span="9" :offset="0"></el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import formatTime from "@/store/timeTotimestr.js";

export default {
  data() {
    return {
      model_data: [{}], // 模板管理表格数据
      model_data_total: 0, // 模板管理表格最大数据量
      view_data: [{}], // 预览模板
      page_num: 1, // 控制页码
      search_status: false, // 控制是否处于搜索状态
      search_data: [{}], // 搜索结果
      search_model_name: "", // 搜索关键字
    };
  },
  methods: {
    // 获取模板管理表格最大数据量
    getTotal() {
      this.$axios({
        method: "post",
        url: "/api/common/dispat",
        data: {
          action: "total",
          data: {
            control: "total",
          },
        },
      }).then((res) => {
        if (res.data.ret == 0) {
          this.model_data_total = res.data.data;
        }
      });
    },
    // 获取模板管理表格数据
    getlist() {
      this.$axios({
        method: "post",
        url: "/api/common/dispat",
        data: {
          action: "list",
          data: {
            paging: 20,
            pagenbr: this.page_num,
          },
        },
      }).then((res) => {
        if (res.data.ret == 0) {
          this.model_data = res.data.data;
        }
      });
    },
    // 时间戳转时间字符串
    changeTime(fmt) {
      return formatTime.setTime(fmt);
    },
    // 删除模板
    delModel(mouldname) {
      this.$confirm("是否删除模板" + mouldname + "?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        this.$axios({
          method: "post",
          url: "/api/common/dispat",
          data: {
            action: "del",
            data: {
              mouldname,
            },
          },
        }).then((res) => {
          if (res.data.ret == 0) {
            this.$message.success(mouldname + "模板删除成功！");
            this.getTotal();
            this.getlist();
          } else if (res.data.ret == 1) {
            this.$message.error(res.data.msg);
          }
        });
      });
    },
    // 获取搜索列表并赋值给search_list
    getSearchList() {
      this.search_status = true;
      this.$axios({
        method: "post",
        url: "/api/common/dispat",
        data: {
          action: "total",
          data: {
            control: "query",
            modelname: this.search_model_name,
          },
        },
      }).then((res) => {
        console.log(res.data);
      });
    },
  },
  mounted() {
    this.getTotal();
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

