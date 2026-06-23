# QueHagoSalta 🌄🍽️

> **Guía turística y comercial digital interactiva para la provincia de Salta.** > Permite a usuarios locales y turistas explorar comercios gastronómicos o peñas, visualizar rutas en mapas interactivos y dejar reseñas validadas para potenciar el comercio local.

---

## 🛠️ Tecnologías Utilizadas

La plataforma está diseñada bajo una arquitectura desacoplada, dividiendo responsabilidades de forma clara:

| Capa | Tecnología | Componentes / Librerías Clave |
| :--- | :--- | :--- |
| **Frontend** | ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white) | `flutter_map`, `provider` (Gestión de Estado), `geolocator`, `image_picker`, `http` |
| **Backend** | ![Django](https://img.shields.io/badge/django-%23092E20.svg?style=flat&logo=django&logoColor=white) | **Django REST Framework (DRF)**, Autenticación Stateless con `SimpleJWT` |
| **Base de Datos** | ![PostgreSQL](https://img.shields.io/badge/postgresql-%23316192.svg?style=flat&logo=postgresql&logoColor=white) | **PostgreSQL** + Extensiones Geográficas (Alojado en **Supabase**) |
| **Mapas y Rutas** | ![OSM](https://img.shields.io/badge/OpenStreetMap-%23741b47.svg?style=flat&logo=openstreetmap&logoColor=white) | **OpenStreetMap (OSM)** & motor de enrutamiento **OSRM** |

---

## 📋 Recursos Necesarios para la Compilación (Prerrequisitos)

Asegúrate de contar con las siguientes herramientas instaladas en tu entorno local antes de iniciar:

* **Flutter SDK**: Versión `3.10` o superior.
* **Python**: Versión `3.9` o superior.
* **Git**: Para la gestión de versiones.
* **IDE Recomendado**: *Visual Studio Code* o *Android Studio*.
* **Entorno de Pruebas**: Emulador Android (AVD) o Dispositivo móvil físico con la *Depuración USB* activa.

---

## 🚀 Instrucciones de Instalación y Ejecución

El proyecto se compone de dos repositorios/carpetas independientes que se comunican mediante una API REST. Deben ejecutarse en terminales separadas.

### 🐍 Parte 1: Configuración del Backend (Django)

1. **Clonar el repositorio y acceder al directorio:**
   ```bash
   git clone [https://github.com/tu-usuario/quehagosalta.git](https://github.com/tu-usuario/quehagosalta.git)
   cd quehagosalta/backend
