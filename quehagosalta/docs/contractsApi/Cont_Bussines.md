Operacion: Lectura(GET)
Tabla en Supabase: bussines
Autenticación Requerida: NO (Acceso Publico)

Entrada(desde Flutter a Supabase){
    latitude = 
    longitude =
}

Salida(desde Supabase a Flutter):
[
  {
    "id": "e3b0c442-98fc-4b01-9a2e-432616234112",
    "name": "Peña Boliche de Balderrama",
    "description": "La peña folclórica más famosa de Salta, con música en vivo y empanadas regionales.",
    "latitude": -24.7854,
    "longitude": -65.4123,
    "address": "San Martín 1126",
    "is_verified": true,
    "created_at": "2026-06-11T15:30:00Z"
  }
]

Detalles:
    id String(uuid) Primary key (autogenerada)
    nombre String (Nombre de la categoria)
    icon_key String (identificador para el mapeo con Icons en flutter)