#coding=utf-8
from django.http import JsonResponse
# from django.shortcuts import HttpResponse
from .import models,logdb,encryption
import json

from rest_framework.decorators import api_view
from rest_framework.authtoken.models import Token
from django.contrib import auth
from django.contrib.auth import login, logout

dolog =logdb.NbLog() 

@api_view(['POST'])
def signin(request):
    try:
        receive = request.data
        username = receive.get('username')
        password = receive.get('password')

        user = auth.authenticate(username=username, password=password)

        if user is not None:
            if user.is_active:
                    if user.is_superuser:
                        login(request,user)
                        # 校验通过
                        # 删除原有的Token
                        old_token = Token.objects.filter(user=user)
                        old_token.delete()
                        # 创建新的Token
                        token = Token.objects.create(user=user)
        
                        # 待加密文本
                        aes_usertype = str(user.usertype)
                        aes_is_active = ''
                        if user.is_active:
                            aes_is_active = '1'
                        else:
                            aes_is_active = '0'
                        aes_is_active = str(user.is_active)
                        #调用加密工具
                        usertype_result = encryption.encrypt(aes_usertype).encryp_add()
                        active_result = encryption.encrypt(aes_is_active).encryp_add()

                        dolog.debug("管理员登陆成功，操作者为：{}".format(user.username))

                        return JsonResponse({'ret': 0 ,"username": user.username, "token": token.key,
                        "usertypen": usertype_result , "is_active" : active_result })
                    else:
                        dolog.error("非管理员登陆，操作者为：{}".format(username))
                        return JsonResponse({'ret': 3, 'msg': '请使用管理员账户登录'})
            else:
                dolog.error("登陆失败，用户已被禁用，操作者为：{}".format(username))
                return JsonResponse({'ret': 2, 'msg': '用户已经被禁用'})
        else:
            dolog.error("登陆失败，用户名或者密码错误，操作者为：{}".format(username))
            return JsonResponse({'ret': 1, 'msg': '用户名或者密码错误'})
    except Exception as e:
        dolog.error("发生异常:{}".format(e))

# 登出处理
@api_view(['POST'])
def signout(request):
    # 使用登出方法
    try:
        logout(request)
    except Exception as e:
        dolog.error("登出失败，发生异常:{}".format(e))
        return JsonResponse({'ret': 1 , 'msg':"登出失败，发生异常:{}".format(e)})  
    return JsonResponse({'ret': 0 })

@api_view(['POST'])
def adduser(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:
                data = json.loads(request.body)
                username = data['username']
                dolog.debug("执行用户添加操作，操作者为：{}".format(username))
        # 直接调用 models中的添加 用户 的代码    
        ret = models.User.add(data)

        return  JsonResponse(ret)

    except Exception as e:
        dolog.error("添加失败，发生异常:{}".format(e))
        return JsonResponse({'ret': 1 , 'msg':"添加失败，发生异常:{}".format(e)})  


@api_view(['POST'])
def deluser(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:

                data = json.loads(request.body)             
                dolog.debug("执行用户删除操作，操作者为：{}".format(request.user.username))
                # 直接调用 models中的删除 用户 的代码    
                ret = models.User.dele(data)

                return  JsonResponse(ret)
    except Exception as e:
        dolog.error("删除失败，发生异常:{}".format(e))
        return JsonResponse({'ret': 1 , 'msg':"登出失败，发生异常:{}".format(e)})  
    
@api_view(['POST'])
def getlist(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:
                data = json.loads(request.body)
                pagenbr = int(data['pagenbr'])
                ret = models.User.ulist(data,pagenbr)
                return  JsonResponse(ret)
    except Exception as e:
        dolog.error("用户列表获取失败，发生异常:{}".format(e))
        return JsonResponse({'ret': 1 , 'msg':"用户列表获取失败，发生异常:{}".format(e)})  

@api_view(['POST'])
def getlist_total(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:  
                data = json.loads(request.body)
                if 'username' in data:
                    uname = data['username']
                else:
                    uname=request.user.username
                ret = models.User.ulist_total(data,uname)
                return  JsonResponse(ret)
    except Exception as e:
        dolog.error("指定用户参数获取失败，发生异常:{}".format(e))
        return JsonResponse({'ret': 1 , 'msg':"指定用户参数获取失败，发生异常:{}".format(e)})  

@api_view(['POST'])
def re_user_active(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:  
                data = json.loads(request.body)
                dolog.debug("已更新{}的禁用状态，操作者为：{}".format(data['username'],request.user.username))                
                ret = models.User.re_active(data)
                return  JsonResponse(ret)
    except Exception as e:
        dolog.error("禁用状态更新发生异常:{}".format(e))  
        return JsonResponse({'ret': 1 , 'msg':"禁用状态更新发生异常:{}".format(e)})  



