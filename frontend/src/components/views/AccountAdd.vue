<template>
  <div id="accountadd">
    <el-form
      :model="account_add_form"
      ref="account_add_form"
      :rules="rules"
      label-width="120px"
      :inline="false"
      size="normal"
    >
      <el-form-item label="用户名" prop="realname">
        <el-input v-model="account_add_form.realname"></el-input>
      </el-form-item>
      <el-form-item label="账号" prop="account">
        <el-input v-model="account_add_form.account"></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input
          type="password"
          show-password
          v-model="account_add_form.password"
        ></el-input>
      </el-form-item>
      <el-form-item label="确认密码" prop="password_again">
        <el-input
          type="password"
          show-password
          v-model="account_add_form.password_again"
        ></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="accountAdd()">提交</el-button>
        <el-button @click="resetForm('account_add_form')">重置</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  props: ["search_status"],
  data() {
    //   所有密码的验证规则
    let validPassword = (rule, value, callback) => {
      let reg = /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$/;
      if (!reg.test(value)) {
        callback(new Error("密码必须是由8-18位字母+数字组合"));
      } else {
        callback();
      }
    };
    // 确认密码要和密码一样
    let againPasswordSame = (rule, value, callback) => {
      if (value != this.account_add_form.password) {
        callback(new Error("密码不一致"));
      } else {
        callback();
      }
    };
    return {
      account_add_form: {
        realname: "",
        account: "",
        password: "",
        password_again: "",
      },
      rules: {
        realname: [
          {
            required: true,
            message: "请输入用户名",
            trigger: "blur",
          },
        ],
        account: [
          {
            required: true,
            message: "请输入账号",
            trigger: "blur",
          },
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          { validator: validPassword, trigger: ["blur", "change"] },
        ],
        password_again: [
          {
            required: true,
            message: "请输入确认密码",
            trigger: "blur",
          },
          { validator: againPasswordSame, trigger: ["blur", "change"] },
        ],
      },
    };
  },
  methods: {
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    // 新增账号
    accountAdd() {
      let self = this;
      this.$refs["account_add_form"].validate((valid) => {
        // 校验通过则请求修改密码
        if (valid) {
          this.$axios
            .post("/api/adminapi/adduser", {
              realname: self.account_add_form.realname,
              username: self.account_add_form.account,
              password: self.account_add_form.password,
            })
            .then((res) => {
              if (res.data.ret == 0) {
                self.$message({
                  type: "success",
                  message: "新建账户成功",
                });
                if (this.search_status) {
                  self.$emit("getSearch");
                } else {
                  self.$emit("getList");
                  self.$emit("getTotal");
                }
              } else if (res.data.ret == 1) {
                self.$message.error(res.data.msg);
              }
            })
            .catch((err) => {
              self.$message({
                type: "error",
                message: "提交失败",
              });
            });
        }
      });
    },
  },
};
</script>

<style scoped></style>
