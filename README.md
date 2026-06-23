QueHagoSalta 🌄🍽️

QueHagoSalta es una guía turística y comercial digital desarrollada para la ciudad de Salta. La plataforma permite a los usuarios (locales y turistas) explorar comercios, visualizar rutas en mapas interactivos y dejar reseñas con fotografías para validar la autenticidad y calidad de los locales gastronómicos.

🛠️ Tecnologías Utilizadas

Frontend: Flutter (Dart) con flutter_map, provider, geolocator, image_picker y http.

Backend: Python 3 con Django y Django REST Framework (DRF).

Base de Datos: PostgreSQL (alojada en Supabase).

Autenticación: JSON Web Tokens (SimpleJWT).

Mapas: OpenStreetMap (OSM) y OSRM (rutas).

📋 Recursos Necesarios para la Compilación (Prerrequisitos)

Para poder compilar y ejecutar este proyecto en tu entorno local, asegúrate de tener instalados los siguientes recursos:

Flutter SDK: Versión 3.10 o superior (Guía de instalación).

Python: Versión 3.9 o superior.

Entorno de Desarrollo (IDE): Visual Studio Code o Android Studio.

Emulador o Dispositivo Físico: Un emulador de Android configurado en Android Studio o un celular físico con la depuración USB activada.

Git: Para clonar el repositorio.

🚀 Instrucciones de Instalación y Ejecución

El proyecto está dividido en dos partes: el servidor (Backend) y la aplicación móvil (Frontend). Se deben ejecutar en terminales separadas.

Parte 1: Configuración del Backend (Django)

Clonar el repositorio y navegar a la carpeta del backend:

git clone [https://github.com/tu-usuario/quehagosalta.git](https://github.com/tu-usuario/quehagosalta.git)
cd quehagosalta/backend


Crear y activar un entorno virtual (recomendado):

# En Windows:
python -m venv venv
.\venv\Scripts\activate

# En Mac/Linux:
python3 -m venv venv
source venv/bin/activate


Instalar las dependencias:
Asegúrate de que tu archivo requirements.txt incluya django, djangorestframework, djangorestframework-simplejwt, psycopg2 y Pillow.

pip install -r requirements.txt


Configurar Variables de Entorno (Base de Datos):
En el archivo settings.py, asegúrate de colocar las credenciales de tu base de datos de Supabase en la configuración DATABASES. Además, verifica que ALLOWED_HOSTS = ['*'] para permitir conexiones desde el celular.

Aplicar migraciones e iniciar el servidor:

python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000


(El backend quedará corriendo en el puerto 8000, listo para recibir peticiones).

Parte 2: Configuración del Frontend (Flutter)

Navegar a la carpeta del frontend y descargar paquetes:
En una nueva terminal, dirígete a la carpeta de la app:

cd quehagosalta/frontend
flutter pub get


Configurar la IP de conexión (¡Paso Crítico!):
Abre el archivo lib/core/api/api_config.dart y configura la variable ipConfigurable dependiendo de cómo vayas a emular la app:

Si usas el Emulador de Android Studio: Usa '10.0.2.2'

Si usas un Celular Físico (vía Wi-Fi): Usa tu IP local (ej. '192.168.1.5'). Descúbrela usando el comando ipconfig en Windows o ifconfig en Mac/Linux.

Si usas un Celular Físico con ADB Reverse (Cable USB): Usa '127.0.0.1'.

Ejecutar la Aplicación:
Conecta tu dispositivo o inicia el emulador y ejecuta:

flutter run

