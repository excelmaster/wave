FROM python:3.11-slim

USER root

# Crear un usuario sin privilegios
RUN useradd -ms /bin/bash supervisoruser

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Cambiar permisos para el directorio /app
RUN chown -R supervisoruser:supervisoruser /app

# Copia los archivos de la aplicación a /app
COPY ./app /app

# Instalar dependencias de la aplicación
COPY ./app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Cambia al usuario no privilegiado
USER root

# Exponer puertos
EXPOSE 8000

# Comando para iniciar supervisord
CMD ["/usr/bin/supervisord"]