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
      <el-form-item label="账号类型" prop="account_type">
        <el-select v-model="account_add_form.account_type" :popper-append-to-body="false" clearable filterable>
          <el-option :value="0" label="员工"></el-option>
        </el-select>
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
    return {
      account_add_form: {
        account: "",
        password: "",
        account_type: ""
      },
      rules: {
        account: [
          {
            required: true,
            message: "请输入账号",
            trigger: "blur"
          }
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          { validator: validPassword, trigger: ["blur", "change"] }
        ],
        account_type: [
          {
            required: true,
            message: "请选择账号类型",
            trigger: ["blur", "change"]
          }
        ]
      }
    };
  },
  methods: {
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    // 新增账号
    accountAdd() {
      let self = this;
      this.$refs["account_add_form"].validate(valid => {
        // 校验通过则请求修改密码
        if (valid) {
          this.$axios
            .post("/", {
              account: self.account,
              password: self.password,
              account_type: self.account_type
            })
            .then(res => {
              self.$message({
                type: "info",
                message: res.data
              });
            })
            .catch(err => {
              self.$message({
                type: "error",
                message: "提交失败"
              });
            });
        }
      });
    }
  }
};
</script>

<style scoped>

</style>