<template>
  <div id="faceadd">
    <van-form class="faceform" @submit="submit">
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
            :max-count="1"
            preview-size="200px"
            :preview-full-image="false"
          />
        </template>
      </van-field>
      <div style="padding: 16px">
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
#faceadd span{
  font-size: 14px;
}
</style>