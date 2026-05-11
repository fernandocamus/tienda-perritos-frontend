# 🐕 Tienda Perritos Frontend

Interfaz de usuario para la gestión de inventario de una tienda en línea de alimentos para perros. Construida con Vanilla JavaScript, HTML5 y CSS3, completamente containerizada con Nginx y Docker.

## 📋 Descripción del Proyecto

Tienda Perritos Frontend es una aplicación web ligera que consume el API REST del backend para gestionar un catálogo de productos. Proporciona una interfaz amigable para listar, crear, editar y eliminar productos en tiempo real.

### Características Principales

✅ Interfaz interactiva y responsiva (CRUD completo)
✅ Consumo de API REST asíncrono (Fetch API)
✅ Proxy inverso con Nginx para enrutamiento seguro
✅ Containerización con Docker (Multi-stage build)
✅ Seguridad: Ejecución con usuario no privilegiado (`nginx`)
✅ CI/CD: Despliegue automatizado con GitHub Actions y AWS

## 🏗️ Arquitectura

┌─────────────────────────────────────────┐
│      Cliente (Navegador Web)            │
└──────────────────┬──────────────────────┘
                   │ HTTP (Puerto 80)
                   ▼
┌──────────────────────────────────────────┐
│      Frontend (Nginx + HTML/JS)          │
│  Contenedor Docker (tienda-frontend)     │
└───────────────────┬──────────────────────┘
                    │ Proxy Inverso (/api/)
                    ▼
┌──────────────────────────────────────────┐
│      Backend (Node.js + Express)         │
│  IP: 10.0.143.90  | Puerto: 3001         │
└──────────────────────────────────────────┘

## 📦 Stack Tecnológico

| Componente | Versión | Descripción |
| :--- | :--- | :--- |
| **HTML/CSS/JS** | Nativo | Estructura, estilos y lógica del cliente. |
| **Nginx** | `stable-alpine` | Servidor web estático y proxy inverso. |
| **Docker** | v20.10+ | Containerización de la aplicación. |
| **GitHub Actions** | - | Pipeline de automatización CI/CD. |
| **AWS ECR/EC2** | - | Registro de imágenes y alojamiento en la nube. |

## 🚀 Instalación y Uso

### Requisitos
* Docker
* Docker Compose
* **El backend debe estar en ejecución y accesible** (ver dependencias en sección de Configuración).

### Opción 1: Con Docker Compose (Recomendado)

```bash
# Clona el repositorio
git clone <repo-url>
cd tienda-perritos-frontend

# Inicia los servicios en segundo plano
docker-compose up --build -d

# Accede a la aplicación
# Abre tu navegador en: http://localhost:80
