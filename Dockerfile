# Usa Python 3.11 como imagen base
FROM python:3.11-slim

# Crear un usuario sin privilegios
RUN useradd -ms /bin/bash supervisoruser

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Crear el directorio de logs de supervisord y cambiar permisos
RUN mkdir -p /var/log/supervisor && \
    chown -R supervisoruser:supervisoruser /var/log/supervisor && \
    chmod -R 777 /var/log/supervisor

# Establecer el directorio de trabajo
WORKDIR /app

# Cambia los permisos de /app para el usuario sin privilegios
RUN chown -R supervisoruser:supervisoruser /app

# Copia los archivos de la aplicación a /app
COPY ./app /app

# Instalar dependencias de la aplicación
COPY ./app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Establecer permisos a la configuración de supervisord
RUN chown -R supervisoruser:supervisoruser /etc/supervisor

# Cambia a usuario sin privilegios para ejecutar el contenedor
USER supervisoruser

# Exponer puertos
EXPOSE 8000

# Comando para iniciar supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
