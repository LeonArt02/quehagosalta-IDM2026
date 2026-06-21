from dataclasses import fields
from dataclasses import field
from rest_framework import serializers
from django.contrib.auth.hashers import make_password

from .models import Categories, Bussines, User, Role, BusinessImage, Review

class CategoriesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categories
        fields = ['id','name','icon_key']

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ['id', 'name', 'description']
        read_only_fields = ['id']

class UserSerializer(serializers.ModelSerializer):
    
    password = serializers.CharField( #Validaciones de seguridad
        write_only=True, 
        required=True, 
        style={'input_type': 'password'}
    )
    
    class Meta :
        model = User
        fields = [
            'id', 
            'firstName', 
            'lastName', 
            'email', 
            'phone', 
            'password', 
            'image', 
            'notification_token', 
            'created_at'
            ]
        read_only_fields = ['id', 'created_at']
    
    def create(self, validated_data):# para encriptar la contraseña antes de que se almacene en Supabase.
        # usamos el algoritmo de Django
        validated_data['password'] = make_password(validated_data['password'])
        # Guarda el usuario con la contraseña ya protegida
        return super().create(validated_data)
    
class BusinessImageSerializer(serializers.ModelSerializer):
    
    bussines_id= serializers.PrimaryKeyRelatedField( 
        queryset=Bussines.objects.all(),
        source='bussines',
        required=False,
        allow_null=True
    )

    class Meta:
        model= BusinessImage
        fields = [
            'id',
            'image_url',
            'bussines_id',
            'created_at'
        ]
    def to_representation(self, instance):
        print(f"SERIALIZANDO IMAGEN: {instance.image_url} para negocio {instance.bussines.id}")
        return super().to_representation(instance)

class BussinesSerializer(serializers.ModelSerializer):

    category= serializers.PrimaryKeyRelatedField( #Reportar funcionamiento
        queryset=Categories.objects.all(),
        required=False,
        allow_null=True
    )

    owner = serializers.PrimaryKeyRelatedField(read_only=True)
    images = BusinessImageSerializer(many=True, read_only=True)

    class Meta:
        model = Bussines
        fields = [
            'id', 
            'name', 
            'description', 
            'latitude', 
            'longitude', 
            'address', 
            'is_verificated', 
            'is_active',   
            'owner',       
            'category',
            'images', 
            'created_at', 
            'updated_at'
        ]
    read_only_fields = ['id', 'owner', 'created_at', 'updated_at']
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        
        if instance.category:
            representation['category'] = {
                'id': str(instance.category.id),
                'name': instance.category.name,
                'icon_key': instance.category.icon_key
            }
        else:
            representation['category'] = None
        
        return representation
        

class ReviewSerializer(serializers.ModelSerializer):
    bussines = serializers.PrimaryKeyRelatedField(
        queryset=Bussines.objects.all(), 
        required=True)
    
    user = serializers.PrimaryKeyRelatedField(
        read_only=True)
    
    class Meta:
        model = Review
        fields = ['id', 
                  'user', 
                  'bussines', 
                  'rate', 
                  'description', 
                  'created_at'
                ]
        
        read_only_fields = ['id', 'user', 'created_at']
        
    def toRepresentation(self, instance):
        representation = super().to_representation(instance)
        
        if instance.user:
            representation['user'] = {
                'id': str(instance.user.id),
                'username': instance.user.firstName + ' ' + instance.user.lastName,
            }

        return representation