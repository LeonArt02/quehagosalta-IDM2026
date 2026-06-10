from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoriesViewSet

# Creamos el enrutador automático
router = DefaultRouter()

# Registramos el ViewSet con el prefijo 'categories'
router.register(r'categories', CategoriesViewSet, basename='categories')

# Las URLs de la app simplemente incluyen todas las rutas que el router fabricó
urlpatterns = [
    path('', include(router.urls)),
]