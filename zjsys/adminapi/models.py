from django.db import models
from .import logdb
# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.hashers import make_password
dolog =logdb.NbLog() 

class User(AbstractUser):
    id = models.BigAutoField(primary_key=True)
    usertype = models.PositiveIntegerField()
    realname = models.CharField(max_length=30, db_index=True)
    phone = models.CharField(max_length=20,verbose_name='手机号')

    class Meta:
        db_table = "zjsys_user"

    # 直接在Model中用静态方法定义数据操作
    @staticmethod
    def add(data,usertype=1,is_superuser=0):
        try:
            un = data['username']
            rn = data['realname']
            if User.objects.filter(username=un).exists():
                dolog.error(f"用户添加失败,登录名 {un} 已经存在")
                return {'ret': 1, 'msg': f'登录名 {un} 已经存在'}
            if User.objects.filter(realname=rn).exists():
                dolog.error(f"用户添加失败,昵称 {rn} 已经存在")
                return {'ret': 1, 'msg': f'昵称 {rn} 已经存在'}


            user = User.objects.create(
                    username  = un,
                    password  = make_password(data['password']),
                    usertype  = usertype,
                    realname  = rn,
                    is_superuser = is_superuser,
                    phone = data['phone']
                )
            dolog.debug("用户添加成功,即时生效")    
            return {'ret': 0,'id': user.id}
        except User.DoesNotExist as e:
            dolog.error("用户添加失败,发生异常:{}".format(e))  
            return{
                'ret': 1,
                'msg': "用户添加失败,发生异常:{}".format(e)
            }

    def dele(data):
        try:
            un = data['username']
            this_user = User.objects.get(username=un)
            if this_user is None or this_user == '':
                dolog.error(f"用户删除失败,登录名 {un} 不存在")
                return {
                'ret': 1,
                'msg': f"用户删除失败,登录名 {un} 不存在"
            }
        except User.DoesNotExist as e:
            dolog.error("用户删除失败,发生异常:{}".format(e))  
            return{
                'ret': 1,
                'msg': "用户删除失败,发生异常:{}".format(e)
            }
        this_user.delete()
        return {'ret':0,"msg":"删除成功"}
    
    def ulist():
        try:
            qs = User.objects.values()
            retlist = list(qs)
            return {'ret':0,'data':retlist}
        except User.DoesNotExist as e:
            dolog.error("发生异常：{}".format(e))
            return{
                    'ret': 1,
                    'msg': "发生异常:{}".format(e)
                }

    def ulist_total():
        try:
            qs = User.objects.count()
            return {'ret':0,'total':qs}
        except User.DoesNotExist as e:
            dolog.error("发生异常：{}".format(e))
            return{
                'ret': 1,
                'msg': "发生异常:{}".format(e)
            }
    
    def re_active(data):
        try:
            un = data['username']
            this_user = User.objects.get(username=un)
            if 're_active' in data:
                if type(data['re_active']) is int:
                    this_user.is_active = int(data['re_active'])
                else:
                    return{
                'ret': 1,
                'msg': "re_active数据类型错误"
            }
                
        except User.DoesNotExist as e:
            dolog.error("发生异常:{}".format(e))  
            return{
                'ret': 1,
                'msg': "发生异常:{}".format(e)
            }
        this_user.save()    
        return {'ret':0,'msg':'禁用状态已更新'}