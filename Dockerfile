FROM raffo1234/orthanc-plugins:23.10.1

# Elimina el CMD heredado que lanza Orthanc automáticamente
ENTRYPOINT []

# Instala supervisor y nginx
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      supervisor \
      nginx \
      python3 && \
    rm -rf /var/lib/apt/lists/*

# Asegura rutas necesarias
RUN mkdir -p /var/lib/orthanc/db

# Copia configuraciones
COPY orthanc.json /etc/orthanc/orthanc.json
COPY nginx_ohif.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

# Expone el puerto para nginx (y proxy a Orthanc)
EXPOSE 80

# Inicia supervisord como único proceso
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
