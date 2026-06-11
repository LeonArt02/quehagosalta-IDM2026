Operacion: Lectura(GET)
Tabla en Supabase: categories
Autenticación Requerida: NO (Acceso Publico)

Entrada(desde Flutter a Supabase){}

Salida(desde Supabase a Flutter):
[
 {
    "id":"cat_001"
    "name":"Restaurante"
    "icon_key":"category_restaurant"
 }
 ...
]

Detalles:
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable = False
    )
    name =  models.CharField(max_length=36, unique=True)
    description =  models.CharField(max_length=280, unique=True)
    latitude = models.FloatField()
    longitude = models.FloatField()
    address = models.CharField(max_length=280)
    is_verificated = models.BooleanField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)