<template>
  <div id="faceadd">
      <h2>新增人脸</h2>
    <van-form @submit="submit">
      <van-field
        type="number"
        :rules="[{ required: true, message: '请填写员工ID' }]"
        required
        name="id"
        label="员工ID"
        v-model="people_id"
      />
      <van-field
        type="text"
        required
        name="name"
        label="员工姓名"
        :rules="[{ required: true, message: '请填写员工姓名' }]"
        v-model="people_name"
      />
      <van-field name="uploader" label="人脸图片上传" required>
        <template #input>
          <van-uploader v-model="face_photo" multiple :max-count="1" preview-size="200px" :preview-full-image="false" />
              
        </template>
      </van-field>
      <div style="margin: 16px">
        <van-button round block type="info" native-type="submit"
          >提交</van-button
        >
      </div>
    </van-form>
  </div>
</template>

<script>
export default {
  name: "faceadd",
  data() {
    return {
      people_id: "",
      people_name: "",
      face_photo: [],
    };
  },
  methods: {

    submit(val) {
        console.log(this.face_photo[0].content);
    },
  },
};
</script>

<style lang="less" scoped>
@max: 100%;
#faceadd {
  width: @max;
  height: @max;
  text-align: center;
}
.preview-cover {
    position: absolute;
    bottom: 0;
    box-sizing: border-box;
    width: 100%;
    padding: 4px;
    color: #fff;
    font-size: 12px;
    text-align: center;
    background: rgba(0, 0, 0, 0.3);
  }
</style>