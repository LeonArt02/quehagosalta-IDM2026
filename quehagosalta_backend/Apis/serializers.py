from dataclasses import field
from rest_framework import serializers
from django.contrib.auth.hashers import make_password

from .models import Categories, Bussines, User, Role

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
    


class BussinesSerializer(serializers.ModelSerializer):

    category_id = serializers.PrimaryKeyRelatedField( #Reportar funcionamiento
        queryset=Categories.objects.all(),
        source='categories',
        required=False,
        allow_null=True
    )

    owner = serializers.PrimaryKeyRelatedField(read_only=True)

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
            'category_id', 
            'created_at', 
            'updated_at'
        ]
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # Eliminamos el id de la salida limpia para que no confunda a Flutter
        representation.pop('category_id', None)
        # Si el local ya tiene asignada una categoría, la serializamos completa
        if instance.category:
            representation['category'] = CategoriesSerializer(instance.category).data
        else:
            representation['category'] = None
            
        return representation
