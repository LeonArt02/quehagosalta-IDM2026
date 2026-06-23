# 🌄🍽️ QueHagoSalta

> **QueHagoSalta** es una guía turística y comercial digital desarrollada para la ciudad de Salta. La plataforma permite a los usuarios (locales y turistas) explorar comercios, visualizar rutas en mapas interactivos y dejar reseñas con fotografías para validar la autenticidad y calidad de los locales gastronómicos.

---

## 🛠️ Tecnologías Utilizadas

* 📱 **Frontend:** Flutter (Dart) con `flutter_map`, `provider`, `geolocator`, `image_picker` y `http`.
* 🐍 **Backend:** Python 3 con Django y Django REST Framework (DRF).
* 🐘 **Base de Datos:** PostgreSQL (alojada en Supabase).
* 🔒 **Autenticación:** JSON Web Tokens (SimpleJWT).
* 🗺️ **Mapas:** OpenStreetMap (OSM) y OSRM (rutas).

---

## 📋 Recursos Necesarios para la Compilación (Prerrequisitos)

Para poder compilar y ejecutar este proyecto en tu entorno local, asegúrate de tener instalados los siguientes recursos:

- [x] **Flutter SDK:** Versión 3.10 o superior ([Guía de instalación](https://docs.flutter.dev/get-started/install)).
- [x] **Python:** Versión 3.9 o superior.
- [x] **IDE (Entorno de Desarrollo):** Visual Studio Code o Android Studio.
- [x] **Emulador o Dispositivo Físico:** Un emulador de Android configurado en Android Studio o un celular físico con la depuración USB activada.
- [x] **Git:** Para clonar el repositorio.

---

## 🚀 Instrucciones de Instalación y Ejecución

El proyecto está dividido en dos partes: el **Servidor (Backend)** y la **Aplicación Móvil (Frontend)**. Se deben ejecutar en terminales separadas para su correcto funcionamiento.

### ⚙️ Parte 1: Configuración del Backend (Django)

**1. Clonar el repositorio y navegar a la carpeta del backend:**
bash
git clone [https://github.com/tu-usuario/quehagosalta.git](https://github.com/tu-usuario/quehagosalta.git)
cd quehagosalta/backend
2. Crear y activar un entorno virtual (Recomendado):

En Windows:

Bash
python -m venv venv
.\venv\Scripts\activate
En Mac / Linux:

Bash
python3 -m venv venv
source venv/bin/activate
3. Instalar las dependencias:

💡 Asegúrate de que tu archivo requirements.txt incluya django, djangorestframework, djangorestframework-simplejwt, psycopg2 y Pillow.

Bash
pip install -r requirements.txt
4. Configurar Variables de Entorno (Base de Datos):
En el archivo settings.py, asegúrate de colocar las credenciales de tu base de datos de Supabase en la configuración DATABASES. Además, verifica que ALLOWED_HOSTS = ['*'] para permitir conexiones desde el celular.

5. Aplicar migraciones e iniciar el servidor:

Bash
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
✅ El backend quedará corriendo en el puerto 8000, listo para recibir peticiones de la red.

📱 Parte 2: Configuración del Frontend (Flutter)
1. Navegar a la carpeta del frontend y descargar paquetes:
Abre una nueva terminal y dirígete a la carpeta de la aplicación móvil:

Bash
cd quehagosalta/frontend
flutter pub get
2. Configurar la IP de conexión (¡Paso Crítico!):

⚠️ Sincronización de Red: Dado que el frontend necesita comunicarse con el servidor local, debes sincronizar las IPs.

En el Frontend: Abre el archivo quehagosalta/core/api/api_config.dart y configura la variable ipConfigurable dependiendo de cómo vayas a emular la app (Ej. tu IP de red local).

En el Backend: Abre el archivo quehagosalta_backend/config/settings.py y configura la variable GLOBAL_IP con tu IP.

3. Ejecutar la Aplicación:
Conecta tu dispositivo físico o inicia el emulador y ejecuta:

Bash
flutter run
