Operacion: Escritura(POST)
Tabla en Supabase: users
Autenticación Requerida: NO (Acceso Publico)

Entrada(desde Flutter a Supabase){
"user": {
    "id": id(autogenerado),
    "name": String,
    "lastname": String,
    "email": Text,
    "phone": Integer,
    "image": (
        URL
        None
    ),
    "notification_token": user.notification_token,
    "roles": Boolean (user=>False, bussines-user=> True),
    }
}

Salida(desde Supabase a Flutter):
[
  Token JWT(JSON Web Token)
]

Detalles:
    