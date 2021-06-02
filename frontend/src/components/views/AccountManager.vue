<template>
  <div id="accountmanager">
    <el-card shadow="always" :body-style="{ padding: '20px' }">
      <!-- card body -->
      <el-row type="flex" justify="space-around" style="height: 40px">
        <el-col :span="1" :offset="0"></el-col>
        <el-col :span="22" :offset="0" style="text-align: right">
          <el-button-group>
            <el-button
              type="success"
              size="default"
              @click="openAccountDrawer()"
              icon="el-icon-circle-plus-outline"
              >新增账号</el-button
            >
            <el-button
              type="warning"
              size="default"
              icon="el-icon-refresh"
              @click="resetList"
              >重置</el-button
            >
            <el-button
              type="primary"
              icon="el-icon-search"
              size="default"
              @click="getSearchList"
              >搜索</el-button
            >
            <el-input
              v-model="search"
              placeholder="请输入任意账号"
              size="normal"
              clearable
              style="width: 200px"
            ></el-input>
          </el-button-group>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>

      <el-row type="flex" justify="space-around" style="margin-top: 5px">
        <el-col :span="1" :offset="0"></el-col>

        <el-col :span="22" :offset="0">
          <el-table
            :data="account_data"
            stripe
            height="700"
            style="font-size: 0.9rem; text-align: center"
          >
            <el-table-column prop="realname" label="用户名"> </el-table-column>
            <el-table-column prop="username" label="账号"> </el-table-column>

            <el-table-column prop="password" label="密码">
              <template slot-scope="scope">
                <el-link
                  type="primary"
                  :underline="false"
                  @click="isNeedPassword(scope.row.username, 'getPassword')"
                >
                  <span>查看</span>
                  <i class="el-icon-view"></i>
                </el-link>
              </template>
            </el-table-column>
            <el-table-column prop="usertype" label="账号类型">
              <template slot-scope="scope">
                <span v-if="scope.row.usertype == 9">管理员</span>
                <span v-else-if="scope.row.usertype == 1">普通用户</span>
              </template>
            </el-table-column>
            <el-table-column label="超级管理员">
              <template slot-scope="scope">
                {{ scope.row.is_superuser ? "是" : "否" }}
              </template>
            </el-table-column>
            <el-table-column prop="is_active" label="账号状态">
              <template slot-scope="scope">
                {{ scope.row.is_active ? "启用" : "停用" }}
              </template>
            </el-table-column>
            <el-table-column align="right" width="600">
              <template slot="header" slot-scope="scope"> 操作</template>
              <template slot-scope="scope">
                <el-button
                  type="primary"
                  icon="el-icon-user"
                  :size="btn_size"
                  round
                  plain
                  @click="isNeedPassword(scope.row.username, 'modPassword')"
                  >修改密码</el-button
                >
                <el-button
                  type="warning"
                  icon="el-icon-warning-outline"
                  :size="btn_size"
                  round
                  plain
                  @click="changeStatus(scope.row.username)"
                  >启用/停用</el-button
                >
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  :size="btn_size"
                  round
                  plain
                  @click="delAccount(scope.row.username)"
                  >删除账号</el-button
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
            :total="account_list_total"
            @current-change="getAccountList"
            :current-page.sync="page_num"
          >
          </el-pagination>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
    </el-card>
    <!-- 修改密码的抽屉 -->
    <el-drawer
      :visible.sync="drawer"
      direction="rtl"
      size="auto"
      :destroy-on-close="true"
      :show-close="true"
      :wrapperClosable="false"
    >
      <h1>修改密码</h1>
      <el-divider direction="horizontal"></el-divider>
      <password-change
        :account="now_account"
        style="margin-right: 20px"
      ></password-change>
    </el-drawer>

    <!-- 新增账号的抽屉 -->
    <el-drawer
      :visible.sync="account_drawer"
      direction="rtl"
      size="auto"
      :destroy-on-close="true"
      :show-close="true"
      :wrapperClosable="false"
    >
      <h1>新增账号</h1>
      <el-divider direction="horizontal"></el-divider>

      <account-add
        @getList="getAccountList"
        @getTotal="getAccountListTotal"
        @getSearch="getSearchList"
        :search_status="search_status"
        style="margin-right: 20px"
      ></account-add>
    </el-drawer>
    <!-- 输入管理员密码的对话框 -->
    <el-dialog
      title="请输入管理员密码"
      :visible.sync="password_visable"
      :close-on-click-modal="false"
      width="30%"
    >
      <el-input
        type="password"
        show-password
        v-model="admin_password"
        size="normal"
        clearable
      ></el-input>

      <span slot="footer">
        <el-button @click="password_visable = false">取消</el-button>
        <el-button type="primary" @click="comparePassword()">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import PasswordChange from "@/components/views/PasswordChange";
import AccountAdd from "@/components/views/AccountAdd";

export default {
  name: "accountmanager",
  data() {
    return {
      account_data: [{}], // 列表数据
      search: "", // 搜索框内容
      search_status: false, // 搜索状态控制
      search_list: [{}], // 搜索结果列表
      btn_size: "medium", // 按钮大小
      admin_password: "", // 管理员密码
      drawer: false, // 修改密码抽屉状态，默认false，关闭
      account_drawer: false, // 新增账号抽屉，默认false，关闭
      now_account: "", // 修改密码的账号
      password_status: false, // 判断是否已经输入过管理员密码的状态
      account_list_total: 0, // 账号管理列表数据量
      page_num: 1, // 控制页码
      password_visable: false, //控制管理员密码输入对话框
    };
  },
  methods: {
    // 新增账号的抽屉
    openAccountDrawer() {
      this.account_drawer = true;
    },
    // 权限控制的抽屉
    openDrawer(account) {
      this.now_account = account;
      this.drawer = true;
    },
    // 启用/停用账号
    changeStatus(account) {
      let self = this;
      // 提示是否启用/停用该账号
      this.$confirm("此操作将启用/停用此账号, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          // 确定则执行操作
          self.$axios
            .post("/api/adminapi/reactive", {
              username: account,
            })
            .then((res) => {
              if (res.data.ret == 0) {
                self.$message({
                  type: "success",
                  message: account + "账号状态已更新",
                });
                if (self.search_status) {
                  self.getSearchList();
                } else {
                  self.getAccountList();
                }
              } else if (res.data.ret == 1) {
                self.$message({
                  type: "error",
                  message: res.data.msg,
                });
              }
            })
            .catch((err) => {
              self.$message.error("操作失败");
            });
        })
        .catch(() => {});
    },
    // 对比管理员密码
    comparePassword() {
      let username = this.$store.state.username;
      let password = this.$AES.encrypt(this.admin_password);
      this.$axios({
        method: "post",
        url: "/api/adminapi/gettotal",
        data: {
          control: "password_md5",
          username: username,
        },
      }).then((res) => {
        if (res.data.ret == 0) {
          if (password == res.data.total[0].password_md5) {
            this.password_status = true;
            this.password_visable = false;
            this.$message.success("密码正确");
          } else {
            this.password_status = false;
            this.password_visable = false;
            this.$message.error("管理员密码错误");
          }
        }
      });
    },
    // 判断是否需要输入管理员密码
    isNeedPassword(account, type) {
      let self = this;
      // 判断是否已经输入过管理员密码
      if (!this.password_status) {
        self.password_visable = true;
        this.now_account = account;
      } else {
        if (type == "getPassword") {
          this.getPassword(account);
        } else if (type == "modPassword") {
          this.openDrawer(account);
        }
      }
    },
    // 获取密码
    getPassword(account) {
      this.$axios({
        method: "post",
        url: "/api/adminapi/gettotal",
        data: {
          control: "password_md5",
          username: account,
        },
      })
        .then((res) => {
          if (res.data.ret == 0) {
            this.$alert(
              "账号" +
                account +
                "的密码为" +
                this.$AES.decrypt(res.data.total[0].password_md5)
            );
          }
        })
        .catch((err) => {
          this.$message.error(err.response.data);
        });
    },
    // 删除账号
    delAccount(account) {
      let self = this;
      this.$confirm("确认是否删除此账号", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          self.$axios
            .post("/api/adminapi/deluser", {
              username: account,
            })
            .then(function (ret) {
              if (ret.data.ret == 0) {
                self.$message({
                  type: "success",
                  message: "删除账号" + account + "成功",
                });
                if (self.search_status) {
                  self.getSearchList();
                } else {
                  self.getAccountList();
                  self.getAccountListTotal();
                }
              } else if (ret.data.ret == 1 || ret.data.ret == 2) {
                self.$message.error(ret.data.msg);
              }
            })
            .catch(function (error) {
              self.$message({
                type: "error",
                message: "删除失败",
              });
            });
        })
        .catch(() => {});
    },
    // 获取账号列表的数据量
    getAccountListTotal() {
      let self = this;
      this.$axios
        .post("/api/adminapi/gettotal", {
          control: "total",
        })
        .then((res) => {
          if (res.data.ret == 0) {
            self.account_list_total = parseInt(res.data.total);
          }
        })
        .catch((err) => {});
    },
    // 获取账号列表
    getAccountList() {
      let self = this;
      // 非搜索状态时
      if (!this.search_status) {
        this.$axios({
          method: "post",
          url: "/api/adminapi/getlist",
          data: {
            paging: 20,
            pagenbr: self.page_num,
          },
        }).then((res) => {
          if (res.data.ret == 0) {
            self.account_data = res.data.data;
          }
        });
      } else {
        self.account_data = []; // 清空列表
        let start_data_num = (self.page_num - 1) * 20; // 20条数据为一页，记录到开始数据序号
        let paging = 0;
        for (let i = start_data_num; i < self.account_list_total; i++) {
          if (paging > 19) {
            return;
          } else {
            self.account_data[i] = self.search_list[i]; // 重新赋值
          }
          paging++;
        }
      }
    },
    // 获取搜索列表
    getSearchList() {
      this.search_status = true;
      if (this.search == "" || this.search == null) {
        this.$message.error("请先输入搜索内容");
      } else {
        this.$axios({
          method: "post",
          url: "/api/adminapi/gettotal",
          data: {
            control: "query",
            username: this.search,
          },
        }).then((res) => {
          if (res.data.ret == 0) {
            this.search_list = res.data.total; // 搜索结果存放到搜索列表
            this.account_list_total = this.search_list.length; // 搜索总数据量放入分页插件的total值
            this.page_num = 1;
            this.getAccountList();
          }
        });
      }
    },
    // 重置列表
    resetList() {
      this.search_status = false;
      this.getAccountListTotal();
      this.getAccountList();
    },
  },
  mounted() {
    this.getAccountListTotal();
    this.getAccountList();
  },
  components: {
    PasswordChange,
    AccountAdd,
  },
};
</script>

<style scoped>
#accountmanager,
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
  height: 1px;
}

::-webkit-scrollbar-thumb {
  border-radius: 5px;
  background-color: rgb(200, 200, 200);
}

#accountmanager .el-table td,
#accountmanager .el-table td span,
#accountmanager .el-table th {
  text-align: center;
  font-size: 15px;
}

#accountmanager .el-table th {
  background-color: #ecf5ff;
}

h1 {
  margin: 10px auto;
  text-align: center;
  font-size: 1.6rem;
}
</style>
