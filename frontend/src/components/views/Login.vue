<template>
  <div id="login">
    <el-card shadow="always" :body-style="{ padding: '20px' }">
      <!-- card body -->
      <el-form
        :model="login_form"
        ref="login_form"
        :rules="login_rules"
        label-width="0px"
        :inline="false"
        size="normal"
        @submit.native.prevent
      >
        <el-form-item>
          <h1
            style="
              display: inline-block;
              font-size: 2rem;
              color: white;
              width: 100%;
            "
          >
            <!-- card title -->
            欢迎登录办公自动化系统
          </h1>
        </el-form-item>
        <el-form-item label="" prop="account">
          <el-input
            v-model="login_form.account"
            prefix-icon="el-icon-user"
          ></el-input>
        </el-form-item>
        <el-form-item label="" prop="password">
          <el-input
            type="password"
            show-password
            prefix-icon="el-icon-lock"
            v-model="login_form.password"
          ></el-input>
        </el-form-item>
        <el-form-item style="text-align: center">
          <el-button
            style="
              width: 80%;
              background-color: #163c69;
              border-color: #163c69;
              border-radius: 30px;
              margin-top: 20px;
            "
            @click="login()"
            native-type="submit"
            type="primary"
            >登录</el-button
          >
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      login_form: {
        account: "",
        password: "",
      },
      login_rules: {
        account: [
          {
            required: true,
            message: "请输入账号",
            trigger: "blur",
          },
        ],
        password: [
          {
            required: true,
            message: "请输入密码",
            trigger: "blur",
          },
        ],
      },
    };
  },
  methods: {
    login() {
      let self = this;
      this.$refs["login_form"].validate((valid) => {
        if (valid) {
          localStorage.removeItem("Authorization");
          self.$axios
            .post("/api/adminapi/signin", {
              username: self.login_form.account,
              password: self.$AES.encrypt(self.login_form.password),
            })
            .then((res) => {
              // 解密用户类型和激活状态
              if (res.data.ret == 0) {
                let usertype = res.data.usertypen;
                let is_active = res.data.is_active;
                let username = res.data.username;
                self.$store.dispatch("login", {
                  token: res.data.token,
                  usertype,
                  is_active,
                  username,
                });
                let usertype_int = parseInt(self.$AES.decrypt(usertype));
                if (usertype_int >= 9) {
                  self.$router.push('/mgr/home');
                  self.$message.success("登录成功");
                }
                // 登录失败
              } else if (res.data.ret == 1 || res.data.ret == 3) {
                self.$message.error(res.data.msg);
              }
            })
            .catch((err) => {});
        }
      });
    },
  },
};
</script>

<style scoped>
#login {
  height: 100%;
  width: 100%;
  background: url(/static/bg.jpg);
  background-attachment: fixed;
  background-position: center;
  background-size: cover;
  position: relative;
}

.el-input {
  width: 80%;
  border: 0;
  border-bottom: 1px #fff solid;
}

.el-card {
  width: 500px;
  position: relative;
  top: 50%;
  margin: 0 auto;
  transform: translateY(-50%);
  text-align: center;
  border: none;
  background: rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

/* .el-card::before {
  content: "";
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background: inherit;
  background-attachment: fixed;
  filter: blur(4px);
  z-index: -1;
} */

h1 {
  margin: 0;
}
</style>

<style>
#login .el-card__header {
  padding: 5px 0;
  border: none;
}

#login .el-form-item__label {
  color: #163c69;
  font-size: 15px;
}

#login .el-form-item__error {
  left: 10%;
}

#login .el-input__inner {
  background: none;
  color: #fff;
  font-size: 18px;
  border-radius: 0;
  box-shadow: #000;
  border: 0;
}
#login .el-input__prefix i {
  color: #fff;
  font-size: 18px;
}

#login .el-form-item__error {
  color: #fff;
  font-size: 16px;
}
</style>
