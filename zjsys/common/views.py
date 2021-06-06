# from django.shortcuts import render
from rest_framework.decorators import api_view
from django.http import JsonResponse
from adminapi import logdb
import json
from common.models import mouldlist

dolog =logdb.NbLog() 

@api_view(['POST'])
def dispatcher(request):

    # try:
    if request.user.is_authenticated:   # 验证Token是否正确
        if request.method == 'GET':
            request.params = request.GET

        # POST/PUT/DELETE 请求 参数 从 request 对象的 body 属性中获取
        elif request.method in ['POST','PUT','DELETE']:
            # 根据接口，POST/PUT/DELETE 请求的消息体都是 json格式
            request.params = json.loads(request.body)


        # 根据不同的action分派给不同的函数进行处理
        action = request.params['action']
        if action == 'list':
            return m_list(request)
        elif action == 'add':
            return m_add(request)
        elif action == 're':  
            return m_re(request)
        elif action == 'del':
            return m_del(request)

        else:
            dolog.error("不支持该类型http请求")
            return JsonResponse({'ret': 1, 'msg': '不支持该类型http请求'})
    else:
        dolog.error("token验证失败")
        return JsonResponse({'ret': 2, "msg": "token验证失败"})

def m_list(request):
    try:
        qs = mouldlist.objects.values()
        retlist = list(qs)
        return JsonResponse({'ret':0,'data':retlist})
    except mouldlist.DoesNotExist as e:
        msg = dolog.error("该路由发生异常:{}".format(e))  
        return JsonResponse({'ret': 9 , 'msg':msg}) 

def m_add(request):
    import time
    try:
        uid = request.user.id
        info = request.params['data']
        mname = request.params['data']['mouldname']
        if mouldlist.objects.filter(mouldname=mname).exists():
                dolog.error("模板名称:{} 已经存在".format(mname))
                return JsonResponse({'ret':1 , 'msg':"模板名称{} 已经存在".format(mname)})
                
        mouldlist.objects.create(mouldname=info['mouldname'],
        mouldjson=info['mouldjson'],
        userid_id = uid,
        create_date = int(time.time()))
        dolog.debug("模板名称:{} 已添加成功".format(mname))
        return JsonResponse({'ret':0})
    except mouldlist.DoesNotExist as e:
        msg = dolog.error("该路由发生异常:{}".format(e))  
        return JsonResponse({'ret': 9 , 'msg':msg}) 

def m_re(request):
    mname = request.params['data']['mouldname']
    newdata = request.params['data']

    try:
        mould = mouldlist.objects.get(mouldname=mname)
    except mouldlist.DoesNotExist as e:
        dolog.error("模板修改失败，发生异常：{}".format(e))
        return JsonResponse({
            'ret': 1,
            'msg': "模板修改失败，发生异常：{}".format(e)
        })

    try:
        if 'mouldname' in newdata:
            mould.mouldname = newdata['mouldname']
        else:
            return JsonResponse({
                'ret': 1,
                'msg': "格式不正确，数据异常"
            })

        if 'mouldjson' in newdata:
            mould.mouldjson = newdata['mouldjson']
        else:
            return JsonResponse({
                'ret': 1,
                'msg': "格式不正确，数据异常"
            })
    except mouldlist.DoesNotExist as e:
        msg = dolog.error("发生异常:{}".format(e))  
        return JsonResponse({'ret': 1 , 'msg':msg}) 

    mould.save()

    return JsonResponse({'ret':0})


def m_del(request):
    try:
        mouldname = request.params['data']['mouldname']
        mould = mouldlist.objects.get(mouldname=mouldname)
    except mouldlist.DoesNotExist as e:
        dolog.error("模板删除失败，发生异常：{}".format(e))
        return JsonResponse({
            'ret': 1,
            'msg': "模板删除失败，发生异常：{}".format(e)
        })
    mould.delete()
    return JsonResponse({'ret':0})