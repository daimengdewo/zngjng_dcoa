import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    Authorization:localStorage.getItem('Authorization')? localStorage.getItem('Authorization'):"",
    usertype:localStorage.getItem('usertype')?localStorage.getItem('usertype'):"",
    is_active:localStorage.getItem('is_active')?localStorage.getItem('is_active'):"",
  },
  mutations:{
    loginChange(state,user){
      state.Authorization=user.token;
      state.usertype=user.usertype;
      state.is_active=user.is_active;
      localStorage.setItem('Authorization',user.token);
      localStorage.setItem('usertype',user.usertype);
      localStorage.setItem('is_active',user.is_active);
      
    },
    loginOut(state){
      state.Authorization="";
      state.is_active="";
      state.usertype="";
      localStorage.setItem('Authorization',"");
      localStorage.setItem('usertype',"");
      localStorage.setItem('is_active',"");
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
