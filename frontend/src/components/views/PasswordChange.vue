<template>
  <div id="passwordchange">
    <el-form
      :model="passwordform"
      ref="passwordform"
      label-width="120px"
      style="font-size: 1.2rem"
      :rules="rules"
    >
      <el-form-item label="原密码：" prop="old_password">
        <el-input
          placeholder="请输入原来的旧密码"
          v-model="passwordform.old_password"
          show-password
        ></el-input>
      </el-form-item>
      <el-form-item label="新密码：" prop="new_password">
        <el-input
          placeholder="请输入新密码"
          v-model="passwordform.new_password"
          show-password
        ></el-input>
      </el-form-item>
      <el-form-item label="确认密码：" prop="new_password_again">
        <el-input
          placeholder="请再次输入一次新密码"
          v-model="passwordform.new_password_again"
          show-password
        ></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="updatePassword()">提交</el-button>
        <el-button @click="resetForm('passwordform')">重置</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  props: ["account"],
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
    let oldAnewPasswordSame = (rule, value, callback) => {
      if (value == this.passwordform.old_password) {
        callback(new Error("新密码不能与旧密码相同"));
      } else {
        callback();
      }
    };
    let againPasswordSame = (rule, value, callback) => {
      if (value != this.passwordform.new_password) {
        callback(new Error("与新密码不一致"));
      } else {
        callback();
      }
    };
    return {
      passwordform: {
        old_password: "",
        new_password: "",
        new_password_again: ""
      },
      rules: {
        //旧密码验证规则
        old_password: [
          { required: true, message: "请输入原密码", trigger: "blur" },
          { validator: validPassword, trigger: ["blur", "change"] }
        ],
        // 新密码验证规则
        new_password: [
          { required: true, message: "请输入新密码", trigger: "blur" },
          { validator: validPassword, trigger: ["blur", "change"] },
          { validator: oldAnewPasswordSame, trigger: ["blur", "change"] }
        ],
        // 确认密码验证规则
        new_password_again: [
          { required: true, message: "请输入确认密码", trigger: "blur" },
          { validator: againPasswordSame, trigger: ["blur", "change"] }
        ]
      }
    };
  },
  methods: {
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    // 修改密码
    updatePassword() {
      let self = this;
      this.$refs["passwordform"].validate(valid => {
        // 校验通过则请求修改密码
        if (valid) {
          this.$axios
            .post("/api/adminapi/repass", {
              // old_pass: self.$AES.encrypt(self.old_password) ,
              // new_pass: self.$AES.encrypt(self.new_password) ,
              old_pass:self.old_password,
              new_pass:self.new_password,
              username: self.account
            })
            .then(res => {
              console.log(self.account);
              if(res.data.ret==0){
                self.$message.success("账号"+self.account+"修改密码成功");
              }else if(res.data.ret==1){
                self.$message.error(res.data.msg);
              }
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
.el-input {
  width: 200px;
}
</style>

<style>
#passwordchange .el-form-item__label {
  font-size: 1rem;
  color: #000;
}

#passwordchange .el-form-item__error {
  font-size: 0.75rem;
}
</style>