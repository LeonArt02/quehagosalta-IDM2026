from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoriesViewSet, BussinesViewSet

# Creamos el enrutador automático
router = DefaultRouter()

router.register(r'categories', CategoriesViewSet, basename='categories')
router.register(r'bussines', BussinesViewSet, basename='bussines')
# Las URLs de la app simplemente incluyen todas las rutas que el router fabricó
urlpatterns = [
    path('', include(router.urls)),
]