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

class Role(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )
    name = models.CharField(max_length=100, unique=True)
    description = models.CharField(max_length=255, null=True, blank=True)

    class Meta:
        db_table = 'roles'

    def __str__(self):
        return self.name

class User(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )
    firstName = models.CharField(max_length=100) 
    lastName = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20)

    image = models.CharField(
        max_length=255,
        null=True,
        blank=True
    )

    password = models.CharField(max_length=255)

    notification_token = models.CharField(
        max_length=255,
        null=True,
        blank=True
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'users' 

    def __str__(self):
        return f"{self.firstName} ({self.email})"

class UserHasRoles(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )
    
    user = models.ForeignKey(
        User, 
        on_delete=models.CASCADE, 
        db_column='user_id' 
    )

    role = models.ForeignKey(
        Role, 
        on_delete=models.PROTECT, 
        db_column='role_id'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'user_has_roles'
        unique_together = ('user', 'role') 

    def __str__(self):
        return f"{self.user.email} -> {self.role.name}"

class Bussines(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable = False
    )
    name =  models.CharField(max_length=100)
    description =  models.TextField(blank=True, null=True)
    latitude = models.FloatField(null=True , blank=True)
    longitude = models.FloatField(null=True , blank=True)
    address = models.CharField(max_length=280, null=True , blank=True)
    is_verificated = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    category = models.ForeignKey(
        Categories,
        on_delete=models.PROTECT,
        related_name='bussines',
        null=True,   
        blank=True
    )

    owner = models.ForeignKey(
        User,
        on_delete=models.CASCADE, 
        related_name='bussines_owned',
        null=True,
        blank=True
    )

    class Meta:
        db_table = 'bussines'

    def __str__(self):
        return self.name    