from django.db import models
from adminapi.models import User

class mouldlist(models.Model):
    # 模板id
    mouldid = models.BigAutoField(primary_key=True)

    # 模板名
    mouldname = models.CharField(max_length=50)

    # 模板json
    mouldjson = models.TextField(max_length=200)

    create_date = models.CharField(max_length=20)

    username = models.ForeignKey(User,max_length=150,to_field='username',on_delete=models.PROTECT)