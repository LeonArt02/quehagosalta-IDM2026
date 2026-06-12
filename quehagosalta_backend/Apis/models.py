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
    name =  models.CharField(max_length=100, unique=True)
    description =  models.TextField(blank=True, null=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=280)
    is_verificated = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    category = models.ForeignKey(
        Categories,
        on_delete=models.PROTECT, # Si borran la categoría, protege al local para que no quede huérfano
        related_name='bussines',
        null=True,   
        blank=True
    )

    class Meta:
        db_table = 'bussines'