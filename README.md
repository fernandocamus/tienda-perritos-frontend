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

```text
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
```

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
```

### Opción 2: Ejecución Local (Sin Docker)
Si el backend se está ejecutando en tu misma máquina local (ej. `http://localhost:3001`):

1. Modifica la variable `API_BASE` en el archivo `app.js` para apuntar a `http://localhost:3001/api/productos`.
2. Abre el archivo `index.html` directamente en tu navegador web.

## 🔌 API Consumida

El frontend espera interactuar con los siguientes endpoints del backend:

| Método | Endpoint | Acción |
| :--- | :--- | :--- |
| **GET** | `/api/productos` | Carga la lista inicial de productos. |
| **GET** | `/api/productos/:id` | Obtiene datos para rellenar el formulario de edición. |
| **POST** | `/api/productos` | Envía el formulario para crear un nuevo producto. |
| **PUT** | `/api/productos/:id` | Envía el formulario para actualizar un producto. |
| **DELETE** | `/api/productos/:id` | Elimina un producto de la tabla. |

## 📁 Estructura del Proyecto

```text
tienda-perritos-frontend/
├── index.html                   # Interfaz de usuario y estilos CSS
├── app.js                       # Lógica Frontend y consumo de API
├── default.conf                 # Configuración del proxy de Nginx
├── Dockerfile                   # Configuración Docker (Multi-stage)
├── docker-compose.yml           # Orquestación del contenedor local
├── .github/
│   └── workflows/
│       └── deploy.yml           # Pipeline de despliegue en AWS
└── README.md                    # Este archivo
```

## 🐳 Docker y Nginx

### Dockerfile (Multi-stage Build)
* **Etapa 1 (Build):** Usa la imagen `node:20-alpine` (alineada con el backend) para organizar los archivos estáticos.
* **Etapa 2 (Runtime):** Usa `nginx:stable-alpine` para servir la web.
* **Seguridad:** Ajusta permisos y usa `USER nginx` para no ejecutar el contenedor como root.

### Proxy Inverso (`default.conf`)
El servidor Nginx está configurado para interceptar cualquier petición a `/api/` y redirigirla internamente.
* **Ruta de destino:** `http://10.0.143.90:3001/api/`

## ☁️ Integración Continua / Despliegue Continuo (CI/CD)

El proyecto cuenta con automatización de despliegue en AWS:

1. **Trigger:** Un `push` a la rama `deploy` inicia el workflow.
2. **Construcción:** GitHub Actions construye la imagen de Docker etiquetada como `latest`.
3. **Registro:** Sube la imagen a Amazon Elastic Container Registry (ECR).
4. **Despliegue:** Se conecta por SSH a Amazon EC2, descarga la imagen y redespliega el contenedor.

## 🔧 Configuración y Personalización

### Cambiar la IP del Backend
Si la IP de la instancia EC2 del backend cambia, **debes actualizar el archivo `default.conf`** antes de compilar la imagen:

```nginx
# En default.conf
location /api/ {
    # Cambiar esta IP por la nueva ubicación del backend
    proxy_pass http://NUEVA_IP:3001/api/; 
}
```

## 🐛 Troubleshooting

**"No se pudieron cargar los productos. ¿Está el backend levantado?" (Error en UI)**
* Verifica que el contenedor del backend está corriendo.
* Confirma que la IP configurada en `default.conf` (actualmente `10.0.143.90`) es correcta y accesible desde el contenedor del frontend.
* Abre las herramientas de desarrollo del navegador (F12) y revisa la pestaña "Network" (Red) para ver si la petición a `/api/productos` devuelve un error `502 Bad Gateway`.

**"Error 502 Bad Gateway"**
* El frontend Nginx está funcionando, pero no puede alcanzar al backend Node.js. Revisa las reglas de seguridad/firewall (Security Groups en AWS) entre ambos servidores.

## 📄 Licencia

Este proyecto es parte del curso de DevOps en DUOC UC.

## 📞 Contacto y Soporte

Para reportar issues o sugerencias, contacta al equipo de desarrollo.
