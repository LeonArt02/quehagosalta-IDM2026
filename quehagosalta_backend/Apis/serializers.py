from rest_framework import serializers

from .models import Categories, Bussines

class CategoriesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categories
        fields = ['id','name','icon_key']

class BussinesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bussines
        fields = ['id','name','description','latitude','longitude','address','is_verificated','created_at','update_at']
