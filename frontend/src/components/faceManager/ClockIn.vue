<template>
  <div>
      

    <div id="map" style="width: 500px; height: 300px"></div>
    <span>纬度：{{ latitude }}</span>
    <span>经度：{{ longitude }}</span>
    <span>错误信息：{{ error_msg }}</span>
    <el-button type="primary" size="default" @click="getLocation"
      >重新定位</el-button
    >
  </div>
</template>

<script>
export default {
  name: "clockin",
  data() {
    return {
      latitude: 0,
      longitude: 0,
      error_msg: "",
    };
  },
  methods: {
    //   获取定位
    getLocation() {
      let self = this;
      AMap.plugin("AMap.Geolocation", function () {
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
          buttonPosition: "RB",
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
        resizeEnable: true,
      });
      var marker = new AMap.Marker({
        position: new AMap.LngLat(longitude, latitude),
      });
      // 将创建的点标记添加到已有的地图实例：
      map.add(marker);
    },
  },
  mounted() {
    this.getLocation();
  },
};
</script>

<style lang="less" scoped>
</style>