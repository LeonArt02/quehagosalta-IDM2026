from django.db import transaction
from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.response import Response
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.conf import settings
from rest_framework import status

from .serializers import CategoriesSerializer, BussinesSerializer, RoleSerializer, UserSerializer
from .models import Categories, Bussines, Role, UserHasRoles



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

class RoleViewSet(viewsets.ModelViewSet):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer

class BussinesViewSet(viewsets.ModelViewSet):
    serializer_class = BussinesSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        user : self.request.user
        base_query = Bussines.objects.select_related('category','owner') #consulta directa de (C,D)

        if self.action == 'List': #filtramos borradores
            return base_query.filter(is_active=True)
        
        return base_query.all()

    @action(detail=False, methods=['patch', 'put'], permission_classes=[IsAuthenticated])
    def complete_profile(self, request):
        try: 
            bussines_instance = Bussines.object.get(owner = request.user)
        except Bussines.DoesNotExist:
            return Response(
                {"message": "No se encontró ningún negocio asociado a tu cuenta comercial."},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = self.get_serializer(bussines_instance, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save(is_active = True)
            return Response({
                "message": "¡Perfil de negocio completado y activado con éxito!",
                "business": serializer.data
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([AllowAny])
def test_api(request):
    return Response({
        'message': 'Django rest_framework funcionando correctamente'
    })

@api_view(['POST'])
def register(request):
    try:
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            is_bussines= request.data.get('is_business',False)
            with transaction.atomic():
                user = serializer.save()
                if is_bussines:
                    target_role = get_object_or_404(Role, name='business_user')
                    UserHasRoles.objects.create(user=user, role=target_role) # Vinculamos al usuario con su rol comercial
                    Bussines.objects.create(
                        owner=user,
                        name=f"Local de {user.firstName}", 
                        is_active=False # Inactivo hasta que llene el formulario 2 en Flutter
                    )
                else:
                    # Flujo tradicional para usuarios comunes
                    target_role = get_object_or_404(Role, name='cliente')
                    UserHasRoles.objects.create(user=user, role=target_role)
            
            refresh_token = getCustomTokenForUser(user)
            access_token = str(refresh_token.access_token)

            roles = Role.objects.filter(userhasroles__user=user)
            roles_serializer = RoleSerializer(roles, many=True)

            response_data = {
                "user": {
                    "id": str(user.id),
                    "firstName": user.firstName, # Corregido: Mismo nombre del modelo
                    "lastName": user.lastName,   # Corregido: Mismo nombre del modelo
                    "email": user.email,
                    "phone": user.phone,
                    "image": f'http://{settings.GLOBAL_IP}:{settings.GLOBAL_HOST}{user.image}' if user.image else None,
                    "notification_token": user.notification_token,
                    "roles": roles_serializer.data,
                },
                "token": "Bearer " + access_token
            }
            return Response(response_data, status=status.HTTP_201_CREATED)

        error_messages = []
        for field, errors in serializer.errors.items():
            for error in errors:
                error_messages.append(f"{field}: {error}")
                
        return Response({
            "message": error_messages,
            "statusCode": status.HTTP_400_BAD_REQUEST
        }, status=status.HTTP_400_BAD_REQUEST)
        
    except Exception as e:
        return Response({
            "message": f"Error crítico en el servidor: {str(e)}"
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def get_custom_token_for_user(user):
    refresh_token = RefreshToken.for_user(user)
    # agregar datos adicionales al payload del token

    refresh_token.payload['id'] = user.id 
    refresh_token.payload['firstName'] = user.firstName 
    return refresh_token


def getCustomTokenForUser(user):
    refresh_token = RefreshToken.for_user(user)
    if 'user_id' in refresh_token.payload:
        del refresh_token.payload['user_id']
    refresh_token.payload['id'] = str(user.id)
    refresh_token.payload['firstName'] = user.firstName
    return refresh_token