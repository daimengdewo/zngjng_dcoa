import Vue from "vue";
import Router from "vue-router";
import main from "@/components/MainWin";
import store from "@/store";
import {
  Message
} from "element-ui";
import AES from "@/AES"

Vue.use(Router);

const originalPush = Router.prototype.push;
Router.prototype.push = function push(location, onResolve, onReject) {
  if (onResolve || onReject) {
    return originalPush.call(this, location, onResolve, onReject);
  }
  return originalPush.call(this, location).catch(err => err);
};

const router = new Router({
  mode: "history",
  routes: [{
      path: "/",
      redirect: "/login"
    },
    {
      path: "/mgr",
      component: main,
      meta: {
        usertype: 9
      },
      children: [{
          path: "",
          name: "home",
          meta: {
            title: "管理后台",
            usertype: 9
          },
          component: () => import("@/components/views/Home")
        },
        {
          path: "accountmanager",
          name: "accountmanager",
          meta: {
            title: "账号管理",
            usertype: 9
          },
          component: () => import("@/components/views/AccountManager")
        }
      ]
    },
    {
      path: "/login",
      component: () => import("@/components/views/Login")
    }
  ]
});

// 路由前置守卫
router.beforeEach((to, from, next) => {
  if (to.path === "/login") {
    next();
  } else {
    let token = localStorage.getItem("Authorization");
    let usertype = parseInt(AES.decrypt(store.state.usertype));
    let is_active = parseInt(AES.decrypt(store.state.is_active));
    if (token === null || token === "") {
      next("/login");
    } else {
      if (usertype >= to.meta.usertype && is_active) {
        next();
      } else {
        Vue.use(Message);
        Message.error("账号权限不足或者账号未激活，无法进入此页面");
        next("/login");
      }
    }
  }
});

export default router;
