from django.core.exceptions import ValidationError
from django.db import IntegrityError, transaction
from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
import os;
from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from django.core.files.storage import FileSystemStorage
from rest_framework_simplejwt.tokens import RefreshToken
# pyrefly: ignore [missing-import]
from rest_framework.response import Response
# pyrefly: ignore [missing-import]
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.conf import settings
from rest_framework import status
from django.contrib.auth.hashers import check_password

from .serializers import CategoriesSerializer, BussinesSerializer, ReviewSerializer, RoleSerializer, UserSerializer, BusinessImageSerializer
from .models import Categories, Bussines, Role, UserHasRoles, User, BusinessImage, Review



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
        # 1. Usamos prefetch_related para traer las imágenes y select_related para optimizar 
        # las llaves foráneas (categoría y usuario) en una sola consulta SQL.
        queryset = Bussines.objects.select_related('category', 'owner')\
                                   .prefetch_related('images')\
                                   .all()

        # 2. Corregimos el nombre de la acción a 'list' (minúsculas)
        if self.action == 'list': 
            return queryset.filter(is_active=True)
        
        return queryset

    @action(detail=False, methods=['patch', 'put'], permission_classes=[IsAuthenticated])
    def complete_profile(self, request):
        user_instance = request.user
        cuil_data = request.data.get('cuil')
    # Capturamos la foto de perfil del dueño que viaja bajo la clave 'image'
        profile_image_file = request.FILES.get('image') 
    
        if not cuil_data or not profile_image_file:
            return Response(
                {"message": "El CUIL y la Foto de Perfil son obligatorios para el alta comercial."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try: 
            bussines_instance = Bussines.objects.get(owner=user_instance)
        except Bussines.DoesNotExist:
            return Response(
              {"message": "No se encontró ningún borrador de negocio asociado a tu cuenta."},
              status=status.HTTP_404_NOT_FOUND
         )
        
        try:
            with transaction.atomic():
            # 1. Procesamos la foto de perfil del dueño (guardamos el string de la ruta)
            # Aquí acoplás tu lógica de guardado físico o subida a Supabase
                user_instance.cuil = cuil_data
                user_instance.image = f"/uploads/profiles/{profile_image_file.name}"
                user_instance.save()
            
            # 2. Actualizamos los datos básicos del local (Nombre, dirección, categoría, etc.)
                serializer = self.get_serializer(bussines_instance, data=request.data, partial=True)
                if serializer.is_valid():
                    serializer.save(is_active=True)
                else:
                    raise ValidationError(serializer.errors)
            
            # 3. EXTRAEMOS LAS FOTOS DE LA GALERÍA DEL LOCAL COMODAMENTE
            # 'business_images' coincide exactamente con la lista enviada por tu multipart de Flutter
                # 📁 En Apis/views.py (dentro de complete_profile)

            gallery_files = request.FILES.getlist('business_images')

            if gallery_files:
    # 🌟 PASO CRÍTICO: Borramos los registros anteriores de imágenes para este negocio
    # Esto asegura que si mandás 2 imágenes, se queden SOLO las 2 que mandaste ahora.
                BusinessImage.objects.filter(bussines=bussines_instance).delete()
    
    # Procedemos a guardar físicamente y registrar en la DB
                for index, file in enumerate(gallery_files):
                    fs = FileSystemStorage(location=os.path.join(settings.MEDIA_ROOT, 'business'))
                    filename = f"{bussines_instance.id}_img_{index}_{file.name}"
                    saved_name = fs.save(filename, file)
        
                    computed_url = f"/uploads/business/{saved_name}"
        
                    BusinessImage.objects.create(
                    bussines=bussines_instance, 
                    image_url=computed_url
                    )    
            
            # 4. RESPUESTA SERIALIZADA
            # Traemos las imágenes recién insertadas mediante su serializador tradicional
                all_images = bussines_instance.images.all()
                images_serializer = BusinessImageSerializer(all_images, many=True)
            
                return Response({
                    "success": True,
                    "message": "¡Datos comerciales, local y galería activados con éxito en Salta!",
                    "business": serializer.data,
                    "images": images_serializer.data # Devuelve el arreglo de IDs y URLs de strings
                }, status=status.HTTP_200_OK)
            
        except Exception as e:
            return Response(
              {"message": f"Error al procesar el formulario: {str(e)}"},
             status=status.HTTP_400_BAD_REQUEST
            )

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
    refresh_token.payload['id'] = str(user.id)
    refresh_token.payload['firstName'] = user.firstName
    return refresh_token


@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    email = request.data.get('email')
    password = request.data.get('password')

    if not email or not password:
        return Response(
            {
                "message": "Email y password son obligatorios",
                "statusCode": status.HTTP_400_BAD_REQUEST
            },
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response(
            {
                "message": "El email o el password no son validos",
                "statusCode": status.HTTP_401_UNAUTHORIZED
            },
            status=status.HTTP_401_UNAUTHORIZED
        )

    
    if check_password(password, user.password):
        
        
        refresh_token = getCustomTokenForUser(user)
        access_token = str(refresh_token.access_token)

        
        roles = Role.objects.filter(userhasroles__user=user)
        roles_serializer = RoleSerializer(roles, many=True)

        
        user_data = {
            "user": {
                "id": str(user.id),
                "lastName": user.lastName,
                "email": user.email,
                "phone": user.phone,
                "image": (
                    f'http://{settings.GLOBAL_IP}:{settings.GLOBAL_HOST}{user.image}'
                    if user.image else None
                ),
                "notification_token": user.notification_token,
                "roles": roles_serializer.data,
            },
            "token": "Bearer " + access_token
        }

        return Response(user_data, status=status.HTTP_200_OK)

    else:
        
        return Response(
            {
                "message": "El email o el password no son validos",
                "statusCode": status.HTTP_401_UNAUTHORIZED
            },
            status=status.HTTP_401_UNAUTHORIZED
        )


class ReviewViewSet(viewsets.ModelViewSet):
    serializer_class = ReviewSerializer
    # # Cualquiera puede ver las reseñas, pero solo logueados pueden crear/editar
    permission_classes = [IsAuthenticatedOrReadOnly]
    
    def get_queryset(self):
        return Review.objects.select_related('user', 'bussines').all()
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        
        if serializer.is_valid():
            try:
                review_instance =serializer.save(user=request.user)  # Asignamos el usuario logueado como autor de la reseña
                return Response({
                    "success": True,
                    "message": "Reseña exitosamente creada :D",
                    "review": self.get_serializer(review_instance).data
                }, status=status.HTTP_201_CREATED)
            except IntegrityError:
                return Response({
                    "success": False,
                    "message": "Ya dejaste una reseña en este negocio. Solo se admite una reseña por negocio."
                }, status=status.HTTP_400_BAD_REQUEST)
            except Exception as e:
                return Response({
                    "success": False,
                    "message": f"Error al crear la reseña: {str(e)}"
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                
                
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)