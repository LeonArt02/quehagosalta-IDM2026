from django.urls import path, include
# pyrefly: ignore [missing-import]
from rest_framework.routers import DefaultRouter



from .views import CategoriesViewSet, BussinesViewSet, register, login,RoleViewSet
# enrutador automático
router = DefaultRouter()

router.register(r'categories', CategoriesViewSet, basename='categories')
router.register(r'bussines', BussinesViewSet, basename='bussines')
router.register(r'roles', RoleViewSet, basename='roles')


urlpatterns = [
    path('', include(router.urls)),
    path('register/', register, name='user_register'),
    path('login/', login, name='use_login'),
]
