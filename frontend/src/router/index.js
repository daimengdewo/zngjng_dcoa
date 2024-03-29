import Vue from "vue";
import Router from "vue-router";
import main from "@/components/MainWin";
import store from "@/store";
import {
  Message
} from "element-ui";
import AES from "@/AES";

Vue.use(Router);

// const originalPush = Router.prototype.push;
// Router.prototype.push = function push(location, onResolve, onReject) {
//   if (onResolve || onReject) {
//     return originalPush.call(this, location, onResolve, onReject);
//   }
//   return originalPush.call(this, location).catch(err => err);
// };

const router = new Router({
  mode: "history",
  routes: [{
      path: "/",
      redirect: "/login"
    },
    {
      path: "/mgr",
      component: main,
      redirect: "/mgr/home",
      meta: {
        usertype: 0
      },
      children: [{
          path: "home",
          name: "home",
          meta: {
            title: "管理后台",
            usertype: 0
          },
          component: () => import("@/components/views/Home")
        },
        {
          path: "accountmanager",
          name: "accountmanager",
          meta: {
            title: "账号管理",
            usertype: 0
          },
          component: () => import("@/components/views/AccountManager")
        },
        {
          path: "model",
          name: "model",
          meta: {
            title: "考勤模板管理",
            usertype: 0
          },
          component: () => import("@/components/views/Model")
        },
        {
          path: "dataExport",
          name: "dataExport",
          meta: {
            title: "数据导出",
            usertype: 0
          },
          component: () => import("@/components/views/DataExport")
        },
        {
          path: "facemanager/:currentPage",
          name: "facemanager",
          meta: {
            title: "人脸数据管理",
            usertype: 0
          },
          component: () => import("@/components/faceManager/FaceManager")
        },
        {
          path: "attencemanager",
          name: "attencemanager",
          meta: {
            title: "考勤数据管理",
            usertype: 0
          },
          component: () => import("@/components/attenceManager/AttenceManager")
        },
        {
          path: "attencerule",
          name: "attencerule",
          meta: {
            title: "考勤规则",
            usertype: 0
          },
          component: () => import("@/components/attenceManager/AttenceRule")
        },
        {
          path: "attencerulemanager",
          name: "attencerulemanager",
          meta: {
            title: "考勤规则管理",
            usertype: 0
          },
          component: () => import("@/components/attenceManager/AttenceRuleManager")
        },
        {
          path: "attencelocationmanager",
          name: "attencelocationmanager",
          meta: {
            title: "考勤地址管理",
            usertype: 0
          },
          component: () => import("@/components/attenceManager/AttenceLocationManager")
        }
      ]
    },
    {
      path: "/login",
      component: () => import("@/components/views/Login")
    },
    {
      path: "/faceadd",
      component: () => import("@/components/faceManager/FaceAdd")
    }, {
      path: "/clockin",
      component: () => import("@/components/faceManager/ClockIn")
    }
  ]
});

// 路由前置守卫
router.beforeEach((to, from, next) => {
  if (to.path == "/login") {
    next();
  } else if (to.path == "/faceadd") {
    next();
  } else if (to.path == "/clockin") {
    next();
  } else {
    let token = localStorage.getItem("Authorization");
    let usertype = parseInt(AES.decrypt(store.state.usertype));
    let is_active = AES.decrypt(store.state.is_active);
    if (token === null || token === "") {
      next("/login");
    } else {
      if (usertype >= to.meta.usertype && is_active == "True") {
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
