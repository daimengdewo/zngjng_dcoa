from django.db import models
from adminapi.models import User
import datetime

class mouldlist(models.Model):
    # 模板id
    mouldid = models.BigAutoField(primary_key=True)

    # 模板名
    mouldname = models.CharField(max_length=50)

    # 模板json
    mouldjson = models.CharField(max_length=200)

    # 用户id
    userid = models.ForeignKey(User,max_length=30,on_delete=models.PROTECT)

    create_date = models.DateTimeField(default=datetime.datetime.now)