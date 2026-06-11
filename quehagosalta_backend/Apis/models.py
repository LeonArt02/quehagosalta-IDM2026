from django.db import models
import uuid
# Create your models here.

class Categories(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable = False
    )
    name = models.CharField(max_length=36, unique=True)
    icon_key = models.CharField(max_length=255)

    class Meta: 
        db_table = 'categories'

class Bussines(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable = False
    )
    name =  models.CharField(max_length=36, unique=True)
    description =  models.CharField(max_length=280, unique=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=280)
    is_verificated = models.BooleanField()
    created_at = models.DateTimeField(auto_now_add=True)
    update_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'bussines'