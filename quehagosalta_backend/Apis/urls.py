from django.urls import path, include
# pyrefly: ignore [missing-import]
from rest_framework.routers import DefaultRouter



<<<<<<< HEAD
from .views import CategoriesViewSet, BussinesViewSet, register, login,RoleViewSet,UserViewSet
=======

from .views import CategoriesViewSet, BussinesViewSet, ReviewViewSet, register, login,RoleViewSet
>>>>>>> 5a3d0d9c231bf412a599a090c013ae42522c9551
# enrutador automático
router = DefaultRouter()

router.register(r'categories', CategoriesViewSet, basename='categories')
router.register(r'bussines', BussinesViewSet, basename='bussines')
router.register(r'roles', RoleViewSet, basename='roles')
<<<<<<< HEAD
router.register(r'users',UserViewSet, basename='user')
=======
router.register(r'reviews', ReviewViewSet, basename='reviews')
>>>>>>> 5a3d0d9c231bf412a599a090c013ae42522c9551


urlpatterns = [
    path('', include(router.urls)),
    path('register/', register, name='user_register'),
    path('login/', login, name='use_login'),
]
