<template>
  <div id="clockin">
    <van-form @submit="onsubmit">
      <div id="map" style="width: 100%; height: 300px"></div>
      <van-cell title="当前位置" icon="location-o" style="height:120px">
        <span>{{ address }}</span>
        <el-button
          @click="getLocation"
          type="text"
          style="position:absolute;right:0px;bottom:5px;padding:0"
          >重新定位</el-button
        >
      </van-cell>
      <van-field
        label="上传图片"
      >
        <template #input>
          <van-uploader
            v-model="face_photo"
            multiple
            :max-count="1"
            preview-size="200px"
            :before-read="beforeRead"
            :preview-full-image="false"
          />
        </template>
      </van-field>
      <div style="margin: 16px;">
        <van-button round block type="info" native-type="submit"
          >考勤打卡</van-button
        >
      </div>
    </van-form>
    
    
  </div>
</template>

<script>
import Vue from "vue";
import { Toast } from "vant";
import tools from "../../store/timeTotimestr"

Vue.use(Toast);

export default {
  name: "clockin",
  data() {
    return {
      latitude: 0,
      longitude: 0,
      error_msg: "",
      address: "",
      face_photo:[],
      file:[]
    };
  },
  methods: {
    //   获取定位
    getLocation() {
      let self = this;
      AMap.plugin("AMap.Geolocation", function() {
        let geolocation = new AMap.Geolocation({
          // 是否使用高精度定位，默认：true
          enableHighAccuracy: true,
          // 设置定位超时时间，默认：无穷大
          timeout: 10000,
          // 定位按钮的停靠位置的偏移量，默认：Pixel(10, 20)
          buttonOffset: new AMap.Pixel(10, 20),
          //  定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
          zoomToAccuracy: true,
          //  定位按钮的排放位置,  RB表示右下
          buttonPosition: "RB"
        });

        geolocation.getCurrentPosition();
        AMap.event.addListener(geolocation, "complete", onComplete);
        AMap.event.addListener(geolocation, "error", onError);
      });
      function onComplete(data) {
        // data是具体的定位信息
        self.latitude = data.position.Q;
        self.longitude = data.position.R;
        self.setMap(self.latitude, self.longitude);
        self.getAddress(self.longitude.toFixed(6), self.latitude.toFixed(6));
      }
      function onError(data) {
        // 定位出错
        self.error_msg = data;
      }
    },
    // 设置地图
    setMap(latitude, longitude) {
      let map = new AMap.Map("map", {
        zoom: 14, //设置地图显示的缩放级别
        center: [longitude, latitude], //设置地图中心点坐标
        mapStyle: "amap://styles/normal", //设置地图的显示样式
        viewMode: "2D", //设置地图模式
        lang: "zh_cn", //设置地图语言类型
        resizeEnable: true
      });
      var marker = new AMap.Marker({
        position: new AMap.LngLat(longitude, latitude)
      });
      // 将创建的点标记添加到已有的地图实例：
      map.add(marker);
    },
    // 获取地址
    getAddress(longitude, latitude) {
      this.$axios({
        method: "get",
        url: `/amap/v3/geocode/regeo?`,
        params: {
          key: "f8eaf56c6169d7ae683b0e84a2231ea4",
          location: `${longitude},${latitude}`,
          extensions: "all"
        }
      }).then(res => {
        if (res.data.status == "1") {
          this.address = res.data.regeocode.formatted_address;
          Toast.success('获取当前地址成功');
        }
      });
    },
    // 上传图片前处理
    beforeRead(file) {
      if (file.size > 1 * 1024 * 1024) {
        const imageConversion = require("image-conversion"); // 导入依赖
        // 压缩图片
        imageConversion.compressAccurately(file, {
          size:1024,
          type: "image/jpeg",
　　　　  width: 500,
　　　　  height: 660,
        }).then((res) => {
          //The res in the promise is a compressed Blob type (which can be treated as a File type) file;
          this.file = res;
        });
      }else{
        this.file=file;
      }
      return true;
    },
    onsubmit(){
      let now=new Date();
      let nowDate=tools.getNowTime(now).now_date;
      let nowTime=tools.getNowTime(now).now_time;
      let formdata=new FormData();
      if(this.file.length==0 || this.address==""){
        Toast.fail("打卡失败，请先拍照或定位异常，请重试");
      }else{
        formdata.append("file",this.file);
        formdata.append("site",this.address);
        formdata.append("date",nowDate);
        formdata.append("time",nowTime);
        this.$axios({
          method:'post',
          url: "/nodeapi/faceapi/clock",
          data: formdata,
          timeout:4500
        }).then(res=>{
          if(res.data.ret==0){
            Toast.success(`打卡成功，打卡时间为\n${nowDate} ${nowTime}`);
          }else if(res.data.ret==1){
            Toast.fail(`打卡失败，人脸库中未查询到该人脸或网络异常，请重试`);
          }
        }).catch(res=>{
          Toast.fail(`打卡失败，照片未识别到人脸或网络异常，请重试`);
        }).finally(() =>{ })
      }
    }
  },
  mounted() {
    this.getLocation();
  }
};
</script>

<style lang="less" scoped>



</style>

<style>
#clockin .van-cell__value {
     -webkit-box-flex: 3; 
     -webkit-flex: 3; 
     flex: 3; 
     text-align: left;
}
</style>
