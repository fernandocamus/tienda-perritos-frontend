# ETAPA 1: Construcción (Build)
FROM node:20-alpine AS build
WORKDIR /app
# Copiamos los archivos necesarios
COPY index.html app.js ./

# ETAPA 2: Ejecución (Servidor Nginx)
FROM nginx:stable-alpine

# SEGURIDAD: Cambiamos permisos para correr como usuario no root
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# 1. Limpiamos la configuración y archivos por defecto
RUN rm -rf /usr/share/nginx/html/*

# 2. Copiamos tus archivos estáticos desde la etapa de build
COPY --from=build /app/index.html /usr/share/nginx/html/
COPY --from=build /app/app.js /usr/share/nginx/html/

# 3. INTEGRACIÓN: Copiamos la configuración del Proxy Inverso
# Este es el paso clave para que el Front vea al Back privado
COPY default.conf /etc/nginx/conf.d/default.conf

# Cambiamos al usuario no privilegiado
USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]