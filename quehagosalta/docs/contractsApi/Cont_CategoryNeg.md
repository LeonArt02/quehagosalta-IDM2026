Operacion: Lectura(GET)
Tabla en Supabase: business_category
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
    id String(uuid) Primary key (autogenerada)
    nombre String (Nombre de la categoria)
    icon_key String (identificador para el mapeo con Icons en flutter)