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