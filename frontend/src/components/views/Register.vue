<template>
  <div>
    <el-form
      :model="register_form"
      ref="register_form"
      :rules="register_rules"
      label-width="90px"
      :inline="false"
      size="normal"
    >
      <el-form-item>
        <h1 style="display: inline-block">
          <!-- card title -->
          注册
        </h1>
      </el-form-item>

      <el-form-item label="账号" prop="account">
        <el-input v-model="register_form.account"></el-input>
      </el-form-item>
      <el-form-item label="部门" prop="department">
        <el-input v-model="register_form.department"></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input
          show-password
          type="password"
          v-model="register_form.password"
        ></el-input>
      </el-form-item>
      <el-form-item label="确认密码" prop="password_again">
        <el-input
          show-password
          type="password"
          v-model="register_form.password_again"
        ></el-input>
      </el-form-item>
      <el-form-item>
        <el-button
          type="primary"
          style="
            width: 100%;
            background-color: #163c69;
            border-radius: 0;
            border-color: #163c69;
          "
          >马上注册</el-button
        >
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
      register_form: {
        account: "",
        password: "",
        password_again: "",
        department: "",
      },
      register_rules: {
        password: [
          {
            required: true,
            message: "请输入密码",
            trigger: "blur",
          },
          { validator: validPassword, trigger: ["blur", "change"] },
        ],
        password_again: [
          {
            required: true,
            message: "请输入确认密码",
            trigger: "blur",
          },
        ],
      },
    };
  },
};
</script>

<style scoped>
</style>