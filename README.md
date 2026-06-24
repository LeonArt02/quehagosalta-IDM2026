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
2. Crear y activar un entorno virtual 

3. Instalar las dependencias:
pip install -r requirements.txt

4. Configurar Variables de Entorno (Base de Datos):
En el archivo settings.py verifica que ALLOWED_HOSTS = ['*'] para permitir conexiones desde el celular.

python manage.py runserver 0.0.0.0:8000

📱 Parte 2: Configuración del Frontend (Flutter)
1. Navegar a la carpeta del frontend y descargar paquetes:
Abre una nueva terminal y dirígete a la carpeta de la aplicación móvil:

Bash
cd quehagosalta/frontend
flutter pub get

2. Configurar la IP de conexión (¡Paso Crítico!):
- Configurar IP con puerto 8000 en quehagosalta/lib/core/api/api_config.dart
- Configurar IP en quehagosalta_backend/config/settings.py, Configurar Variable GLOBAL_IP

3. Ejecutar la Aplicación:

Bash
flutter run
