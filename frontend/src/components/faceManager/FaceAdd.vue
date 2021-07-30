<template>
  <div id="faceadd">
    <van-form class="faceform" @submit="lastSubmit">
      <h2 style="margin: 0; padding: 10px 0; box-shadow: 0 8px 12px #ebedf0">
        新增人脸
      </h2>
      <van-field
        class="faceform"
        type="number"
        :rules="[{ required: true, message: '请填写员工ID' }]"
        required
        name="id"
        label="员工ID"
        v-model="people_id"
      />
      <van-field
        class="faceform"
        type="text"
        required
        name="name"
        label="员工姓名"
        :rules="[{ required: true, message: '请填写员工姓名' }]"
        v-model="people_name"
      />
      <van-field
        readonly
        clickable
        class="faceform"
        required
        name="department"
        label="部门"
        :value="people_department"
        :rules="[{ required: true, message: '请选择部门' }]"
        @click="showPicker = true"
      />
      <van-field
        class="faceform"
        name="uploader"
        label="人脸图片上传"
        required
        :rules="[{ required: true, message: '请上传人脸照片' }]"
      >
        <template #input>
          <van-uploader
            v-model="face_photo"
            multiple
            capture="camera"
            :max-count="1"
            preview-size="200px"
            :before-read="beforeRead"
            :preview-full-image="false"
          />
        </template>
      </van-field>
      <div style="padding: 16px">
        <van-button round block type="info" :disabled="!submit_button_status" native-type="submit"
          >提交</van-button
        >
      </div>
    </van-form>
    <van-popup v-model="showPicker" position="bottom">
      <van-picker
        show-toolbar
        :columns="department_list"
        @confirm="setDepartment"
        @cancel="showPicker = false"
      />
    </van-popup>
  </div>
</template>

<script>
import Vue from "vue";
import { Toast } from "vant";

Vue.use(Toast);

export default {
  name: "faceadd",
  data() {
    return {
      people_id: "",
      people_name: "",
      people_department: "",
      department_list: [],
      face_photo: [],
      file: "",
      showPicker: false,
      submit_button_status:true
    };
  },
  methods: {
    async submit(val) {
      let formdata = new FormData();
      formdata.append("url", "file");
      formdata.append("file", this.file);
      formdata.append("id", val["id"]);
      formdata.append("nm", val["name"]);
      formdata.append("set", "1");
      formdata.append("BM", val["department"]);
      const post = () => {
        return new Promise((resolve, reject) => {
          this.$axios({
            method: "post",
            url: "/nodeapi/faceapi/upload",
            data: formdata,
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }).then((res) => {
            resolve(res.data.ret);
          });
        });
      };
      return await post();
    },
    async pySubmit(val) {
      const post = () => {
        return new Promise((resolve, reject) => {
          this.getBase64(this.file).then((res) => {
            this.$axios({
              method: "post",
              url: "/api/userapi/newface",
              data: {
                id: val["id"],
                name: val["name"],
                face: res.split(",")[1],
              },
            }).then((res) => {
              resolve(res.data.code);
            });
          });
        });
      };
      return await post();
    },
    lastSubmit(val) {
      this.submit_button_status=false;
      Promise.all([this.submit(val), this.pySubmit(val)]).then((res) => {
        this.submit_button_status=true;
        if (res[0] == 0 && res[1] == 200) {
          Toast.success("新增人脸成功");
        } else {
          Toast.fail("新增人脸失败,请检查照片或网络");
        }
      });
    },
    getBase64(file) {
      return new Promise((resolve, reject) => {
        let reader = new FileReader();
        let fileResult = "";
        reader.readAsDataURL(file);
        //开始转
        reader.onload = function () {
          fileResult = reader.result;
        };
        //转 失败
        reader.onerror = function (error) {
          reject(error);
        };
        //转 结束  咱就 resolve 出去
        reader.onloadend = function () {
          resolve(fileResult);
        };
      });
    },
    // 图片放入预览前的处理
    beforeRead(file) {
      if (file.size > 1 * 1024 * 1024) {
        const imageConversion = require("image-conversion"); // 导入依赖
        // 压缩图片
        imageConversion
          .compressAccurately(file, {
            size: 1024,
            type: "image/jpeg",
            width: 500,
            height: 660,
          })
          .then((res) => {
            //The res in the promise is a compressed Blob type (which can be treated as a File type) file;
            this.file = res;
          });
      } else {
        this.file = file;
      }
      return true;
    },
    showDepartment() {
      this.$axios({
        method: "post",
        url: "/nodeapi/faceapi/BMlist",
      }).then((res) => {
        let data_array = [];
        for (let i = 0; i < res.data.length; i++) {
          data_array[i] = res.data[i].BM;
        }
        this.department_list = data_array;
      });
    },
    setDepartment(val) {
      this.people_department = val;
      this.showPicker = false;
    },
  },
  mounted() {
    this.showDepartment();
  },
};
</script>

<style lang="less" scoped>
@max: 100%;
#faceadd {
  width: @max;
  height: @max;
  text-align: center;
  background-color: #f7f8fa;
}
.faceform {
  background-color: #fff;
}
</style>

<style>
#faceadd .van-uploader__upload {
  border-radius: 12px;
}
#faceadd span {
  font-size: 14px;
}
</style>