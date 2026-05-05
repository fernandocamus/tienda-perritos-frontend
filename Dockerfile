# ETAPA 1: Construcción (Build)
# Usamos una imagen de Node para preparar los archivos si fuera necesario
FROM node:20-alpine AS build
WORKDIR /app
COPY . .

# ETAPA 2: Ejecución (Servidor Nginx)
# Usamos un Nginx ligero
FROM nginx:stable-alpine

# SEGURIDAD: Cambiamos permisos para que Nginx pueda correr sin ser root
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Copiamos los archivos estáticos desde la etapa de build
COPY --from=build /app/index.html /usr/share/nginx/html/
COPY --from=build /app/app.js /usr/share/nginx/html/

# Cambiamos al usuario no privilegiado que ya trae la imagen de Nginx
USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
