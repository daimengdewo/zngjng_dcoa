import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    Authorization:localStorage.getItem('Authorization')? localStorage.getItem('Authorization'):"",
    usertype:localStorage.getItem('usertype')?localStorage.getItem('usertype'):"",
    is_active:localStorage.getItem('is_active')?localStorage.getItem('is_active'):"",
    username:localStorage.getItem('username')?localStorage.getItem("username"):""
  },
  mutations:{
    loginChange(state,user){
      state.Authorization=user.token;
      state.usertype=user.usertype;
      state.is_active=user.is_active;
      state.username=user.username;
      localStorage.setItem('Authorization',user.token);
      localStorage.setItem('usertype',user.usertype);
      localStorage.setItem('is_active',user.is_active);
      localStorage.setItem('username',user.username);
    },
    loginOut(state){
      state.Authorization="";
      state.is_active="";
      state.usertype="";
      state.username="";
      localStorage.setItem('Authorization',"");
      localStorage.setItem('usertype',"");
      localStorage.setItem('is_active',"");
      localStorage.setItem('username',"");
    }
  },
  actions:{
    login(context,user){
      context.commit('loginChange',user);
    },
    loginOut(context){
      context.commit('loginOut');
    }
    
  }
});
