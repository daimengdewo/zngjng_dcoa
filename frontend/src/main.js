// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue";
import App from "./App";
import router from "./router";
import axios from "axios";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import "default-passive-events";
import store from "./store";
import AES from "./AES";


axios.defaults.withCredentials = true

// 添加请求拦截器，在请求头中加token
axios.interceptors.request.use(
  config => {
    if (localStorage.getItem('Authorization')) {
      config.headers.Authorization = localStorage.getItem('Authorization');
    }
 
    return config;
  },
  error => {
    console.log(error);
    return Promise.reject(error);
    
  });


Vue.use(ElementUI);
Vue.prototype.$AES = AES;
Vue.prototype.$axios = axios;
Vue.config.productionTip = false;




/* eslint-disable no-new */
new Vue({
  el: "#app",
  router,
  store,
  components: { App },
  template: "<App/>"
});
