from django.db import models
from .import logdb,encryption
# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.hashers import make_password
dolog =logdb.NbLog() 

class User(AbstractUser):
    id = models.BigAutoField(primary_key=True)
    usertype = models.PositiveIntegerField()
    realname = models.CharField(max_length=30, db_index=True)
    phone = models.CharField(max_length=20,verbose_name='手机号')
    password_md5 = models.CharField(max_length=100,default="")

    class Meta:
        db_table = "zjsys_user"

    # 直接在Model中用静态方法定义数据操作
    @staticmethod
    def add(data,usertype=1,is_superuser=0):
        try:
            un = data['username']
            rn = data['realname']
            ps = data['password']
            if User.objects.filter(username=un).exists():
                dolog.error(f"用户添加失败,登录名 {un} 已经存在")
                return {'ret': 1, 'msg': f'登录名 {un} 已经存在'}
            if User.objects.filter(realname=rn).exists():
                dolog.error(f"用户添加失败,昵称 {rn} 已经存在")
                return {'ret': 2, 'msg': f'昵称 {rn} 已经存在'}


            user = User.objects.create(
                    username  = un,
                    password  = make_password(ps),
                    password_md5 = encryption.encrypt(ps).encryp_add(),
                    usertype  = usertype,
                    realname  = rn,
                    is_superuser = is_superuser
                )
            dolog.debug("用户{}添加成功,即时生效".format(un))    
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
            if this_user.is_superuser == 1:
                return{
                'ret': 2,
                'msg': "无法删除超级用户"
            }
        except User.DoesNotExist as e:
            dolog.error("用户删除失败,发生异常:{}".format(e))  
            return{
                'ret': 1,
                'msg': "用户删除失败,发生异常:{}".format(e)
            }
        this_user.delete()
        return {'ret':0,"msg":"删除成功"}
    
    def ulist(data,pagenbr=1):
        paging = int(data['paging'])
        try:
            qs = User.objects.values('realname','username','usertype','is_active','is_superuser').order_by('id')[paging*pagenbr-paging:paging*pagenbr]
            retlist = list(qs)
            return {'ret':0,'data':retlist}
        except User.DoesNotExist as e:
            dolog.error("用户列表获取失败，发生异常:{}".format(e))
            return{
                    'ret': 1,
                    'msg': "用户列表获取失败，发生异常:{}".format(e)
                }

#指定数据查询
    def ulist_total(data,uname):
        try:
            control = data['control']
            if control is not None:
                if control == 'total':
                    retlist = User.objects.count()
                elif control == 'query':
                    qs = User.objects.filter(username__contains=uname).values('realname','username','usertype','is_active','is_superuser')
                    retlist = list(qs)
                else:
                    qs = User.objects.filter(username=uname).values(control)
                    retlist = list(qs)
                return {'ret':0,'total':retlist}
        except User.DoesNotExist as e:
            dolog.error("指定用户参数获取失败，发生异常:{}".format(e))
            return {
                    'ret': 9,
                    'msg': "指定用户参数获取失败，发生异常:{}".format(e)
                }
    
#禁用状态更新
    def re_active(data):
        try:
            uname = data['username']
            this_user = User.objects.get(username=uname)
            if this_user.is_superuser == 0:
                if this_user.is_active == 1:
                    this_user.is_active = 0
                elif this_user.is_active == 0:
                    this_user.is_active = 1
            else:
                dolog.error("禁用状态更新失败，无法禁用超级用户")  
                return {'ret': 1, 'msg': "禁用状态更新失败，无法禁用超级用户"}
        except User.DoesNotExist as e:
            dolog.error("禁用状态更新失败，发生异常:{}".format(e))  
            return {'ret': 9, 'msg': "禁用状态更新失败，发生异常:{}".format(e)}
        this_user.save()    
        return {'ret': 0, 'msg': "用户{}的禁用状态更新成功".format(uname)}
    
    def re_pass(data):
        try:
            uname = data['username']
            opass = data['old_pass']
            npass = data['new_pass']
            this_user = User.objects.get(username=uname)
            if this_user.password_md5 == encryption.encrypt(opass).encryp_add():
                this_user.set_password(npass)
                this_user.password_md5 = encryption.encrypt(npass).encryp_add()
            else:
                return {'ret': 1 ,'msg': "用户密码修改失败，跟原密码匹配失败"}
        except User.DoesNotExist as e:
            return {'ret': 9 ,'msg': "用户密码修改失败，发生异常:{}".format(e)}
        this_user.save()    
        return {'ret': 0 ,'msg': '用户{}的密码已更新'.format(uname)}