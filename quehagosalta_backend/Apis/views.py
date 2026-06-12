from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status

from .serializers import CategoriesSerializer, BussinesSerializer
from .models import Categories, Bussines



#from rest_framework_simplejwt.tokens import RefreshToken


# GET -> OBTENER
# POST -> CREAR
# PUT -> ACTUALIZAR
# DELETE -> BORRAR

# 200 rpta exitosa
# 400 o 500 Error

class CategoriesViewSet(viewsets.ModelViewSet):
    queryset = Categories.objects.all()
    serializer_class = CategoriesSerializer

class BussinesViewSet(viewsets.ModelViewSet):
    queryset = Bussines.objects.select_related('category').all()
    serializer_class = BussinesSerializer
    #permission_classes = [IsAuthenticatedOrReadOnly]