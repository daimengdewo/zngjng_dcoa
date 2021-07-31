
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthtokenToken(models.Model):
    key = models.CharField(primary_key=True, max_length=40)
    created = models.DateTimeField()
    user = models.ForeignKey('ZjsysUser', models.DO_NOTHING, unique=True)

    class Meta:
        managed = False
        db_table = 'authtoken_token'


class CommonMouldlist(models.Model):
    mouldid = models.BigAutoField(primary_key=True)
    mouldname = models.CharField(max_length=50)
    mouldjson = models.TextField()
    create_date = models.CharField(max_length=20)
    username = models.ForeignKey('ZjsysUser', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'common_mouldlist'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey('ZjsysUser', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Face(models.Model):
    faceid = models.CharField(max_length=255, blank=True, null=True)
    id = models.CharField(db_column='ID', primary_key=True, max_length=255)  # Field name made lowercase.
    name = models.CharField(max_length=255, blank=True, null=True)
    set = models.CharField(db_column='Set', max_length=255, blank=True, null=True)  # Field name made lowercase.
    bm = models.CharField(db_column='BM', max_length=50, blank=True, null=True)  # Field name made lowercase.
    qj = models.CharField(db_column='QJ', max_length=255, blank=True, null=True)  # Field name made lowercase.
    qjdate1 = models.CharField(db_column='QJdate1', max_length=255, blank=True, null=True)  # Field name made lowercase.
    qjdate2 = models.CharField(db_column='QJdate2', max_length=255, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'face'


class Guize(models.Model):
    bm = models.CharField(db_column='BM', unique=True, max_length=50, blank=True, null=True)  # Field name made lowercase.
    content = models.TextField(blank=True, null=True)
    bmid = models.AutoField(db_column='BMid', primary_key=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'guize'


class Jingwei(models.Model):
    sid = models.AutoField(primary_key=True)
    lnglat = models.CharField(db_column='LngLat', max_length=255, blank=True, null=True)  # Field name made lowercase.
    bm = models.CharField(db_column='BM', max_length=255, blank=True, null=True)  # Field name made lowercase.
    address = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'jingwei'


class Kaoqin(models.Model):
    id = models.CharField(db_column='ID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    device = models.CharField(max_length=255, blank=True, null=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    nbr = models.CharField(max_length=255, blank=True, null=True)
    date = models.DateField(blank=True, null=True)
    time = models.TimeField(blank=True, null=True)
    bm = models.CharField(db_column='BM', max_length=50, blank=True, null=True)  # Field name made lowercase.
    type = models.CharField(max_length=255, blank=True, null=True)
    deviceno = models.CharField(max_length=255, blank=True, null=True)
    datetime = models.CharField(max_length=255, blank=True, null=True)
    direction = models.CharField(max_length=255, blank=True, null=True)
    nid = models.AutoField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'kaoqin'


class ZjsysUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()
    id = models.BigAutoField(primary_key=True)
    usertype = models.PositiveIntegerField()
    realname = models.CharField(max_length=30)
    phone = models.CharField(max_length=20)
    password_md5 = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'zjsys_user'


class ZjsysUserGroups(models.Model):
    user = models.ForeignKey(ZjsysUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'zjsys_user_groups'
        unique_together = (('user', 'group'),)


class ZjsysUserUserPermissions(models.Model):
    user = models.ForeignKey(ZjsysUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'zjsys_user_user_permissions'
        unique_together = (('user', 'permission'),)
