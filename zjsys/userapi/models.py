from django.db import models

# Create your models here.
class Face(models.Model):
    faceid = models.CharField(max_length=255, blank=True, null=True)
    id = models.CharField(db_column='ID', primary_key=True, max_length=255)  # Field name made lowercase.
    name = models.CharField(max_length=255, blank=True, null=True)
    set = models.CharField(db_column='Set', max_length=255, blank=True, null=True)  # Field name made lowercase.
    bm = models.CharField(db_column='BM', max_length=50, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        db_table = 'face'


class Guize(models.Model):
    bm = models.CharField(db_column='BM', unique=True, max_length=50, blank=True, null=True)  # Field name made lowercase.
    content = models.TextField(blank=True, null=True)  # This field type is a guess.
    bmid = models.AutoField(db_column='BMid', primary_key=True)  # Field name made lowercase.

    class Meta:
        db_table = 'guize'


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
        db_table = 'kaoqin'