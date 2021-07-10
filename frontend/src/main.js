// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue";
import App from "./App";
import axios from "axios";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import "default-passive-events";
import store from "./store";
import AES from "./AES";
import md5 from "js-md5";
import router from "./router";
import Vant from "vant";
import "vant/lib/index.css";

axios.defaults.withCredentials = true;

// 添加请求拦截器，在请求头中加token
axios.interceptors.request.use(
  config => {
    if (localStorage.getItem("Authorization")) {
      config.headers.Authorization = localStorage.getItem("Authorization");
    }

    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 全局捕捉请求错误
axios.interceptors.response.use(
  response => {
    // Do something before response is sent
    return response;
  },
  error => {
    // Do something with response error
    if (error.response.status == 401) {
      let res_data = error.response.data;
      if (res_data.ret == 3) {
        router.push("/login");
        store.dispatch("loginOut");
        ElementUI.Message.error("token已过期，请重新登录");
      } else if (res_data.ret == 1) {
        router.push("/login");
        store.dispatch("loginOut");
        ElementUI.Message.error("token验证失败，请重新登录");
      }
    }
    return Promise.reject(error);
  }
);

Vue.use(Vant);
Vue.use(ElementUI);
Vue.prototype.$AES = AES;
Vue.prototype.$md5 = md5;
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
