<template>
  <div id="databaseconnect">
    <el-form
      :model="databaseconnect_form"
      ref="databaseconnect_form"
      :rules="rules"
      label-width="120px"
      size="normal"
    >
      <el-form-item label="Host" prop="host">
        <el-input
          placeholder="请输入连接地址"
          v-model="databaseconnect_form.host"
        ></el-input>
      </el-form-item>
      <el-form-item label="用户名" prop="user">
        <el-input
          placeholder="请输入用户名"
          v-model="databaseconnect_form.user"
        ></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input
          type="password"
          placeholder="请输入密码"
          v-model="databaseconnect_form.password"
        ></el-input>
      </el-form-item>
      <el-form-item label="端口" prop="port">
        <el-input
          type="number"
          placeholder="请输入端口"
          v-model="databaseconnect_form.port"
        ></el-input>
      </el-form-item>
      <el-form-item label="数据库" prop="database">
        <el-input
          placeholder="请输入连接的数据库"
          v-model="databaseconnect_form.database"
        ></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="connect()">测试连接</el-button>
        <el-button @click="resetForm('databaseconnect_form')">重置</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      databaseconnect_form: {
        host: "",
        user: "",
        password: "",
        port: "",
        database: ""
      },
      rules: {
        host: [{ required: true, message: "请输入连接地址", trigger: "blur" }],
        user: [{ required: true, message: "请输入用户名", trigger: "blur" }],
        password: [{ required: true, message: "请输入密码", trigger: "blur" }],
        port: [{ required: true, message: "请输入端口", trigger: "blur" }],
        database: [{ required: true, message: "请输入数据库", trigger: "blur" }]
      }
    };
  },
  methods: {
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    connect() {
      let self = this;
      this.$refs["databaseconnect_form"].validate(valid => {
        // 校验通过则请求连接数据库
        if (valid) {
          this.$axios
            .post("/", {
              host: self.host,
              user: self.user,
              password: self.password,
              port: self.port,
              database: self.database
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