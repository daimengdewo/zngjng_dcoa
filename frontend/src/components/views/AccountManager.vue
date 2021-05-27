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
            <el-button type="primary" icon="el-icon-search" size="default"
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
                  @click="getPassword(scope.row.account)"
                >
                  <span>查看</span>
                  <i class="el-icon-view"></i>
                </el-link>
              </template>
            </el-table-column>
            <el-table-column prop="usertype" label="账号类型">
              <template slot-scope="scope">
                <span v-if="scope.row.usertype == 9">管理员</span>
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
                  @click="openDrawer(scope.row.account)"
                  >权限控制</el-button
                >
                <el-button
                  type="warning"
                  icon="el-icon-warning-outline"
                  :size="btn_size"
                  round
                  plain
                  @click="changeStatus(scope.row.account)"
                  >启用/停用</el-button
                >
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  :size="btn_size"
                  round
                  plain
                  @click="delAccount(scope.row.account)"
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
            @prev-click="getAccountList"
            @next-click="getAccountList"
          >
          </el-pagination>
        </el-col>
        <el-col :span="1" :offset="0"></el-col>
      </el-row>
    </el-card>

    <el-drawer
      :visible.sync="drawer"
      direction="rtl"
      size="auto"
      :destroy-on-close="true"
      :show-close="true"
      :wrapperClosable="true"
    >
      <password-change
        :account="now_account"
        style="margin-right: 20px"
      ></password-change>
    </el-drawer>
    <el-drawer
      :visible.sync="account_drawer"
      direction="rtl"
      size="auto"
      :destroy-on-close="true"
      :show-close="true"
      :wrapperClosable="true"
    >
      <h1>新增账号</h1>
      <el-divider direction="horizontal"></el-divider>

      <account-add style="margin-right: 20px"></account-add>
    </el-drawer>
  </div>
</template>

<script>
import $ from "jquery";
import PasswordChange from "@/components/views/PasswordChange";
import AccountAdd from "@/components/views/AccountAdd";

export default {
  name: "accountmanager",
  data() {
    return {
      account_data: [
        // 列表数据
        {
          realname: "管理员",
          account: "admin",
          account_type: "管理员",
          account_status: "可用",
          is_superuser: true,
        },
      ],
      search: "", // 搜索框内容
      btn_size: "medium", // 按钮大小
      admin_password: "", // 管理员密码
      drawer: false, // 修改密码抽屉状态，默认false，关闭
      account_drawer: false, // 新增账号抽屉，默认false，关闭
      now_account: "", // 修改密码的账号
      password_status: false, // 判断是否已经输入过管理员密码的状态
      account_list_total: 0, // 账号管理列表数据量
    };
  },
  methods: {
    // 新增账号的抽屉
    openAccountDrawer() {
      this.account_drawer = true;
    },
    // 权限控制的抽屉
    openDrawer(account) {
      let self = this;
      // 判断是否已经输入过管理员密码了
      if (this.password_status == false) {
        this.$alert(
          '<div class="el-input"><input class="el-input__inner" type="password" id="admin_password" size="normal" clearable></input></div>',
          "请输入管理员密码",
          {
            dangerouslyUseHTMLString: true,
          }
        )
          .then(() => {
            // 获取弹出层数据
            self.admin_password = $("#admin_password").val();
            self.$axios
              .post("/", {
                admin_password: self.admin_password,
                account: account,
              })
              // 请求成功弹出修改密码界面
              .then(function (ret) {
                self.password_status = true;
                self.now_account = account;
                self.drawer = true;
              })
              .catch(function (error) {
                self.$message({
                  type: "info",
                  message: "获取密码失败",
                });
              });
          })
          .catch(() => {});
        // 如果输入过管理员密码则直接打开界面
      } else {
        self.now_account = account;
        self.drawer = true;
      }
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
            .put("/change_account_status", {
              account: account,
            })
            .then((res) => {
              self.$message({
                type: "success",
                message: res.data,
              });
            })
            .catch((err) => {
              self.$message.error("操作失败");
            });
        })
        .catch(() => {});
    },
    // 查看密码
    getPassword(account) {
      let self = this;
      // 判断是否已经输入过管理员密码
      if (this.password_status == false) {
        this.$alert(
          '<div class="el-input"><input class="el-input__inner" type="password" id="admin_password" size="normal" clearable></input></div>',
          "请输入管理员密码",
          {
            dangerouslyUseHTMLString: true,
          }
        )
          .then(() => {
            // 获取弹出层数据
            self.admin_password = $("#admin_password").val();
            self.$axios
              .post("/", {
                admin_password: self.admin_password,
                account: account,
              })
              // 请求成功弹出真实密码
              .then(function (ret) {
                self.password_status = true;
                self.$alert(ret.data, "该账号的密码是");
              })
              .catch(function (error) {
                self.$message({
                  type: "info",
                  message: "获取密码失败",
                });
              });
          })
          .catch(() => {});
      } else {
        self.$axios
          .post("/", {
            admin_password: self.admin_password,
            account: account,
          })
          // 请求成功弹出真实密码
          .then(function (ret) {
            self.$alert(ret.data, "该账号的密码是");
          })
          .catch(function (error) {
            self.$message({
              type: "info",
              message: "获取密码失败",
            });
          });
      }
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
            .post("", {
              account: account,
            })
            .then(function (ret) {
              self.$message({
                type: "success",
                message: "删除成功",
              });
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
          control: "password_md5",
        })
        .then((res) => {
          if (res.data.ret == 0) {
            // self.account_list_total = parseInt(res.data.total);
            console.log(res.data.total[0].password_md5);
            console.log(self.$AES.decrypt(res.data.total[0].password_md5));
          }
        })
        .catch((err) => {});
    },
    // 获取账号列表
    getAccountList(val) {
      let page_num = val ? val : 1;
      let self = this;
      this.$axios({
        method: "post",
        url: "/api/adminapi/getlist",
        data: {
          paging: 20,
          pagenbr: page_num,
        },
      }).then((res) => {
        if (res.data.ret == 0) {
          self.account_data = res.data.data;

        }
      });
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
